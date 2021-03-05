set -e

if [[ -z $1 ]]; then
  echo "Enter new version: "
  read VERSION
else
  VERSION=$1
fi

read -p "Releasing $VERSION - are you sure? (y/n) " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
  echo "Releasing $VERSION ..."

  # npm run lint
  # npm run test

  # build
  VERSION=$VERSION npm run build
  VERSION=$VERSION npm run docs

  cd docs
  git add -A
  git commit -m "[build] $VERSION"
  git push --set-upstream origin
  cd -

  # commit
  git add -A
  git commit -m "[build] $VERSION"
  npm version $VERSION --message "[release] $VERSION"

  # publish
  git push --set-upstream origin refs/tags/v$VERSION
  git push --set-upstream
  # npm config set registry http://registry.npmjs.org
  # npm publish
fi
