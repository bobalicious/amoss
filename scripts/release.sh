# packager
git stash push --message tmp-packager
git reset --hard

rm -rf ../force-app/amoss_examples

sfdx force:package:version:create -p amoss -d ../force-app --wait 10 -v amoss-dev-hub -x

git reset --hard
git merge --squash stash
git reset