
getio <- function(folder = '2002年各省份投入产出表', rows = 6:57, cols = 3:59){
  flexcel <- paste('data-raw/中国31省区市42部门投入产出表1997-2017皮皮侠/',folder, sep = '') %>% dir()
  fl <- flexcel[!str_detect(flexcel, '^~')] %>%
    paste('data-raw/中国31省区市42部门投入产出表1997-2017皮皮侠',folder,., sep = '/')

  exampl2002 <- xlsx::read.xlsx(fl[2],1, rowIndex = rows, colIndex = cols)
  rowsec2002 <- names(exampl2002)
  colsec2002 <- exampl2002[,1]

  io2002 <- list()
  for (i in 1:length(fl)) {
    if (str_detect(flexcel[i], '中国')) next
    ans <- xlsx::read.xlsx(fl[i],1,rowIndex = rows, colIndex = cols)
    if (!(identical(names(ans), rowsec2002) & identical(ans[,1], colsec2002))){
      print(fl[i])
      break
    }

    # 修改部门名称为sec01等
    names(ans) <- str_replace(names(ans),'^X','sec') %>% str_remove('\\.')
    ans[1:42,1] <- paste('sec',ans[1:42,1], sep = '')
    # 去除各种小合计
    ans <- ans[,names(ans)[!str_detect(names(ans),'TIU|THC|TC|GCF|TFU')]]
    ans <- ans[!ans$sec %in% c('TII'),]
    io2002[[str_remove_all(flexcel[i],'-|[0-9]|\\.xls')]] <- ans
  }
  return(io2002)
}
