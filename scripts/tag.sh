VERSION=$1
if [ "$#" -eq 0 ] 
  then
  echo "Usage: $0 VERSION"
  exit 1
fi

# try to delete the version if it exists
git tag -d $VERSION || echo "Version $VERSION doesn't exist yet"
git tag -a $VERSION -m $VERSION
git push origin $VERSION
echo "Pushed $VERSION to origin"

