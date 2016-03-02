## Variable assignment
x<-rnorm(10)

## Vectors
vect<- c(1,2,3,4)
vect1<-c(5,6)
xvect<-vect + (vect1*2)
print(xvect)
print("length of vector using length()")
print (length(vect))
print("vectors recycle")
print(c(1,2,4) + c(6,0,9,20,22))
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
  #they also have modes, such as numeric and character. 
  #(On the other hand, vectors are not one-column or one-row matrices.)
  
  #storage of a matrix is in column-major order
  m<-matrix(c(1,2,3,4), ncol=2)
  print (m)
  

## Lists
Lst <- list(name="Fred", wife="Mary", no.children=3, child.ages=c(4,7,9))

## Functions
q<-function(x, y)
{
  z<-y+x
}

print(q(44,11))
## builtin functions
x<-c(1,2,3,4)
print (length(x))