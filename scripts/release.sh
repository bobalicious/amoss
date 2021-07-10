echo ""
echo ------------------------------------------------------------------------------------------------------
echo Execute from the root of the project, when you are on main, ideally with no changes in the workspace
echo Double check you don\'t have any files that are ignored in git
echo And that you have updated the PENDING_RELEASE_NOTES
echo ------------------------------------------------------------------------------------------------------
echo ""
echo Getting Latest Version Information
echo ------------------------------------------------------------------------------------------------------
sfdx force:package:version:list -p amoss -o CreatedDate | tail -1

echo ""
echo Enter new version number - major.minor.patch.build
read newversionnumber

newversionname=v$newversionnumber
echo ""
echo New Version Name / Tag: $newversionname
echo ""

echo Resetting GIT workspace
echo ------------------------------------------------------------------------------------------------------
rm -rf ./force-app/amoss_examples

# We do this first in case we're accidentally releasing the same version number again
echo ""
echo Tagging with $newversionname
echo ------------------------------------------------------------------------------------------------------
git tag -a $newversionname -m "Release $newversionnumber"

echo ""
echo Building unlocked package
echo ------------------------------------------------------------------------------------------------------
sfdx force:package:version:create -p amoss -d force-app --wait 10 -v amoss-dev-hub -x -n $newversionnumber -a $newversionname -t $newversionname -c
echo ""
echo Getting new package\'s Id and Alias
echo ------------------------------------------------------------------------------------------------------
newversionid=$(sfdx force:package:version:list -p 'amoss' -o CreatedDate --concise | tail -1 | awk '{print $3}')
newversionalias=$(sfdx force:package:version:list -p 'amoss' -o CreatedDate | tail -1 | awk '{print $5}')

echo ""
echo Updating references in the README to: $newversionalias / $newversionid
echo ------------------------------------------------------------------------------------------------------

sed -i '' -E "s/force:package:install --package \"(.*)\"/force:package:install --package \"$newversionalias\"/" README.md
sed -i '' -E "s/installPackage.apexp\?p0=(.*)/installPackage.apexp\?p0=$newversionid/" README.md
echo ""
echo Updating RELEASE_NOTES with PENDING_RELEASE_NOTES
echo ------------------------------------------------------------------------------------------------------
./scripts/combine-release-notes.sh $newversionnumber $newversionname "sfdx force:package:install --package \"$newversionalias\"" "https://login.salesforce.com/packaging/installPackage.apexp?p0=$newversionid" "https://test.salesforce.com/packaging/installPackage.apexp?p0=$newversionid"

echo ""
echo Committing change to SFDX configuration
echo ------------------------------------------------------------------------------------------------------
git add sfdx-project.json
git add README.md
git add RELEASE_NOTES.md
git add PENDING_RELEASE_NOTES.md

git commit -m "Added version $newversionname"
git push
git tag -fa $newversionname -m "Release $newversionnumber"
git push origin $newversionname

echo ""
echo Reverting GIT workspace
echo ------------------------------------------------------------------------------------------------------
git reset

echo ""
echo Done
echo ""
echo Test be creating a new scratch org:
echo  sfdx force:org:create -f config/default-scratch-def.json -a testamossrelease --setdefaultusername
echo And then release to it with the sfdx force:package:install command from the release notes
echo When happy, release with:
echo  sfdx force:package:version:promote --package "$newversionalias"