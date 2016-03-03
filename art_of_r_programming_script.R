## Variable assignment
x<-rnorm(10)

## Vectors
  # all items in a vector must me the same mode (type)
vect<- c(1,2,3,4)
vect1<-c(5,6)
xvect<-vect + (vect1*2)
print(xvect)
print("length of vector using length()")
print (length(vect))
print("vectors recycle")
print(c(1,2,4) + c(6,0,9,20,22, 55))
  # Vector Indexing
  # start at 1
  # vector1[vector2]
  # negative subscripts mean exclude
  # : colon gives range of numbers
  # seq, a general of the : (supports steps)
  # rep .... rep(x, how many times)
  # any(vector operation) -- if any are true
  # all(vector operation) -- if all are true
  print("functions are vectorized sqrt(1:9) is:")
  print(sqrt(1:9))
  print("even + is vectorized '+'(5,4)")
  print("+"(5,4))
  # NA is missing, NULL is not exists
  # NULL is a special R object with no mode.
  # subset removes NAs
  print("which returns a positional vector")
  z <- c(5,2,-3,8)
  print(which(z*z > 8))
  # ifelse(b,u,v)
  # where b is a Boolean vector, and u and v are vectors.
  # names can be assigned to a vector!  and refed by vec['name']  !!
  
## Matrices
  print("Matrices!")
  # A matrix is a vector with two additional attributes: 
  #the number of rows and the number of columns. Since matrices are vectors, 
  #they also have modes, such as numeric and character.  one matrix/one mode
  #(On the other hand, vectors are not one-column or one-row matrices.)
  
  #storage of a matrix is in column-major order (can override with byrow)
  m<-matrix(c(1,2,3,4), ncol=2)
  print (m)
  
  # apply functions are for matrices!!!!
  # apply(matrix,dimcode - 1 row, 2 col,function,fargs)
  z<-apply(m,1,sum)
  z1<-apply(m,2,sum)
  print(z)
  print(z1)
  
  # cbind adds cols, rbind rows, uses recyclinng, so if short must be a multiple
  # can also name matrices
  # arrays are mXn so a general case of matrices

## Lists
  # lists are a type of vector, can be created by the vector function
  # z <- vector(mode="list")
  Lst <- list(name="Fred", wife="Mary", no.children=3, child.ages=c(4,7,9))
  # can get items a few ways:
  # $ and double brackets [[]]
  print(Lst$name)
  print(Lst[['name']])
  print(Lst[[1]])
  # in a list, the single bracket returns a sublist
  qwerty<-Lst[1]
  print(class(qwerty))
  print(qwerty)
  print("========")
  
  # can add items to a list (like a vector)
  j <- list(name="Joe", salary=55000, union=T)
  Lst$qqq<-j
  # or Lst[[x]]<-j -- but Lst[x] will not work as this R wants
  # to put each item in the list in a separate master list slot
  
  #unlist unpacks a list into a vector -- uses lowest common denom for vector type
  # NULL < raw < logical < integer < real < complex < character < list < expression
  # also keeps the names
  v<-unlist(j)
  print(v)
  # can remove names with unname
  v1<-unname(v)
  print(v1)
  
  # lapply is apply but for lists!!!!!
  la<-lapply(list(1:3,25:29), mean)
  print(la)
  # sapply will simplify to a vector or matrix (depending on output)
  sa<-sapply(list(1:3,25:29), mean)
  print (sa)

## DataFrames!
  # A data frame is a list, with the components of that list being equal-length vectors.
  # you can go more complicated actually, but this is rare in practice
  
  # create, stringsasfactors should be false, unless you want char vectors to be factors
  ages <- c(12,10)
  kids <- c("Jack","Jill")
  d <- data.frame(kids,ages,stringsAsFactors=FALSE)
  d1 <- data.frame(kids,ages)
  
  # access, since a list, same way to get ITEMS
  print(d$kids)
  print(d[[1]])
  
  # sub data frame is
  print(d[1])
  
  # but can get info like a matrix
  print(d[,1])  #note that d[1,] justs gives back a df -- kinda weird
  # not really, a column in a df is one type -- but mult rows will by default
  # made to give back a df
  
  # merge merges df's like a join in sql
  hobbies <- c("bball","karate")
  d2 <- data.frame(kids,hobbies,stringsAsFactors=FALSE)
  print(d)
  print(d2)
  print(merge(d,d2))
# Factors
  # factors are things like sex, gender -- a set of valid values
  # char vectors are set by default (see above)
  # can also use the factor function
  # factors also act as valid values
  x <- c(5,12,13,12)
  xf <- factor(x)
  print(str(xf))
  print(xf)
  # tapply(x,f,g) has x as a vector, f as a factor or list of factors, and g as a function.
  ages <- c(25,26,55,37,21,42)
  affils <- c("R","D","D","R","U","D")
  print(tapply(ages,affils,mean))
  
  # split is like tapply light
  #split(x,f)
  
  d <- data.frame(list(gender=c("M","M","F","M","F","F"),
  age=c(47,59,21,32,33,24),income=c(55000,88000,32450,76500,123000,45650)))
  d$over25 <- ifelse(d$age > 25,1,0)
  print(split(d$income,list(d$gender,d$over25)))
  
  # by()
  # Calls to by() look very similar to calls to tapply(), 
  # with the first argument specifying our data, the second the grouping factor, 
  # and the third the function to be applied to each group.
  
# Tables
  #???
  fl <- list(c(5,12,13,12,13,5,13),c("a","bc","a","a","bc","a","a"))
  print(fl)
  # to get a count of the list (how the items are related), we use table
  print(table(fl))
  
  # aggregate and cut are used with tables