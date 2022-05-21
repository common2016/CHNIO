## 皮皮侠的分省数据整理
rm(list = ls())
library(pacman)
p_load(stringr, devtools)
load_all()

# 代码和名称
flexcel <- paste('data-raw/中国31省区市42部门投入产出表1997-2017皮皮侠/','2002年各省份投入产出表', sep = '') %>% dir()
fl <- flexcel[!str_detect(flexcel, '^~')] %>%
  paste('data-raw/中国31省区市42部门投入产出表1997-2017皮皮侠','2002年各省份投入产出表',., sep = '/')

secnames <- xlsx::read.xlsx(fl[2],1,rowIndex = c(3,6), colIndex = 4:57, header = FALSE) %>%
  t() %>% as.data.frame()
names(secnames) <- c('nm','code')
secnames$nm[secnames$code %in% 'FU101'] <- '农村居民消费'
secnames$nm[secnames$code %in% 'FU102'] <- '城镇居民消费'
secnames$nm[secnames$code %in% 'THC'] <- '居民消费小计'
secnames$nm[secnames$code %in% 'FU103'] <- '政府消费'
secnames$nm[secnames$code %in% 'TC'] <- '消费小计'
secnames$nm[secnames$code %in% 'FU201'] <- '固定资本形成总额'
secnames$nm[secnames$code %in% 'FU202'] <- '存货增加'
secnames$nm[secnames$code %in% 'GCF'] <- '资本形成总额合计'

ans <- xlsx::read.xlsx(fl[2],1,rowIndex = c(49:55), colIndex = 2:3, header = FALSE)
names(ans) <- c('nm','code')
ans$nm[ans$code %in% 'TI'] <- '总投入'
secnames <- rbind(secnames, ans)
secnames$year02 <- 2002
secnames$year07 <- 2007
secnames$year12 <- 2012
secnames$year17 <- 2017
# 2007
secnames <- data.frame(nm = c('流出','流入','其他'),code = c('FU302','FU304','ERR'),year02 = NA,
                       year07 = 2007, year12 = c(NA,NA,2012), year17 = c(NA,NA,2017)) %>% rbind(secnames, .)
# 2012,2017
secnames <- data.frame(nm = c('出口','国内省外流出','进口','国内省外流入'),code = c('EX','OF','IM','IF'),year02 = NA,
                       year07 = NA, year12 = 2012, year17 = 2017) %>% rbind(secnames, .)
secnames$nm <- str_remove_all(secnames$nm,'\n')
secnames[secnames$code %in% 'NOF',c('year07','year12','year17')] <- NA
# usethis::use_data(secnames, overwrite = TRUE)

# 2002
io2002 <- getio('2002年各省份投入产出表')

# 2007
io2007 <- getio('2007年各省份投入产出表', rows = 8:57)
io2007[['安徽']]$FU202 <- as.numeric(io2007[['安徽']]$FU202)

# 2012
io2012 <- getio('2012年各省份投入产出表', rows = 9:58, cols = 3:61)

# 2017
io2017 <- getio('2017年各省份投入产出表', rows = 8:57, cols = 3:61)

# usethis::use_data(io2002, io2007, io2012, io2017, overwrite = TRUE)
