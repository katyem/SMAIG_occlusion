## calculate the percentage of each cube's visibility by using total stack area as the denomiator.


##install.packages('imager')
library('imager')
library(xlsx) 
getwd()
setwd("D:/R stuff/SMAIG_occlusion/")
picPath <- "smaigColor/"  ## CHANGE to appropriate image sub-folder
im_names <- list.files (path = picPath); #folder with pictures in your working directory

cubesInStack <- 10 # number of cubes per stack/image; WARNING: I haven't tried changing this yet!

# Identify 10 different colors and count the occurrence to determine cube occlussion
# rows == colors of each cube
cubeColor  <- matrix(
c(0, 0, 1,
   1, 0.3, 0.3,
   0.5, 1, 0,
   0.5, 0.3, 0.1,
   0, 1, 1,
   0, 0.4, 0,
   0.6, 0, 0.8,
   0.7, 0.7, 0.7,
   1, 1, 1,
   1, 1, 0,
    0, 0, 0), ncol=11,nrow=3)  ## The colors used for each of ten cubes (three color channels vs the one used in gray scale)

cNames = c('blue', 'brown1', 'chartreuse1', 'chocolate4', 'cyan', 'darkgreen', 'darkviolet', 'gray', 'white', 'yellow', 'black')

colnames(cubeColor) <-  cNames

thisColor <- c(0,0,0) #used to store pixel channel values
imCount <- 0
colorCount <- matrix(0, NROW(im_names), NCOL(cubeColor) )  # set up matrix: images==rows
colnames(colorCount) <-  cNames
rownames(colorCount) <- im_names

for (imName in im_names) {
  ##temp <- paste(picPath, imName, sep='') 
  im <- load.image(paste(picPath, imName, sep=''))  #sets the name of the image in the loop que
  imCount <- imCount + 1 # increment the count for the loop (there is most likely a better way to do this)
  # I really miss double plus incrementation (word?): imCount++;
  tempCount = 0
  
  for (x in 1:width(im)) {  # width 
    for (y in 1:height(im)) {  # height 
      thisColor[1] <- round(as.numeric(im[x,y,1,1]),1) # The 1st color  of the pixel at location x,y
      thisColor[2] <- round(as.numeric(im[x,y,1,2]),1) # The 2nd color  of the pixel at location x,y
      thisColor[3] <- round(as.numeric(im[x,y,1,3]),1) # The 3rd color  of the pixel at location x,y
      
          for (cc in 1:NCOL(cubeColor)) {
            #if (thisColor[1] == cubeColor[1,cc] && thisColor[2] == cubeColor[2,cc] && thisColor[3] == cubeColor[3,cc]) {
            if (thisColor[1] == cubeColor[1,cc] && thisColor[2] == cubeColor[2,cc] && thisColor[3] == cubeColor[3,cc]) {
                colorCount[imCount, cc] = colorCount[imCount, cc] + 1
            }
          }
       # }
      

    }
  }  
  print(imName);  print(imCount);
}

## Run code below to save to xls file
write.xlsx(colorCount, "colorCount.xlsx", col.names=T, row.names=T) # each column = image; rows = non-black color categories (.1-1); black == 0, white = 1


