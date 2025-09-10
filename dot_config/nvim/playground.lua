cursor = { 3, 0 }
sequence = "\27]7;file//DESKTOP-UID0111/home/widehyo/.vim/util"
-- invalid dir: ^[]7;file//DESKTOP-UID0111/home/widehyo/.vim/util
print(string.gsub(sequence, 'file//[^/]*', ''))

