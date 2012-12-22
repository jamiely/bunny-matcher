VERSION=$1
[ "$#" -eq 1 ] || die "Version required"
# try to delete the version if it exists
git tag -d $VERSION || echo "Version $VERSION doesn't exist yet"
git tag -a $VERSION -m $VERSION
git push origin $VERSION
echo "Pushed $VERSION to origin"

