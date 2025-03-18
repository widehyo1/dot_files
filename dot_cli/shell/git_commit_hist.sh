for branch in $(git branch -r | grep -v '\->'); do 
  printf "===\n"; 
  git log $branch --pretty=format:"%h|%ad|$branch|%s|by %an" --date=short; 
  printf "\n"; 
done
