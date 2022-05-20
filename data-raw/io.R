## 皮皮侠的分省数据整理
rm(list = ls())
library(pacman)
p_load(stringr, devtools)
load_all()

# 2002
io2002 <- getio('2002年各省份投入产出表')

# 2007
io2007 <- getio('2007年各省份投入产出表', rows = 8:57)

# 2012
io2012 <- getio('2012年各省份投入产出表', rows = 9:58, cols = 3:61)

# 2017
io2017 <- getio('2017年各省份投入产出表', rows = 8:57, cols = 3:61)

# usethis::use_data(io2002, io2007, io2012, io2017, overwrite = TRUE)
