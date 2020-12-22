# packager
echo ""
echo Getting Latest Version Information
sfdx force:package:version:list -p amoss -o CreatedDate | tail -1

echo ""
echo Enter new version number:
read newversionnumber

newversionname=v$newversionnumber
echo ""
echo New Version Name / Tag: $newversionname
echo ""

echo Resetting GIT workspace
echo -----------------------------------------------------------------------
git stash push --message tmp-packager
git reset --hard

rm -rf ./force-app/amoss_examples

echo ""
echo Tagging with $newversionname
echo -----------------------------------------------------------------------
git tag -a $newversionname -m "Release $newversionnumber"
git push origin $newversionname

echo ""
echo Building unlocked package
echo -----------------------------------------------------------------------
sfdx force:package:version:create -p amoss -d force-app --wait 10 -v amoss-dev-hub -x -n $newversionnumber -a $newversionname

echo ""
echo Reverting GIT workspace
echo -----------------------------------------------------------------------
git reset --hard
git merge --squash stash
git reset

echo ""
echo Done