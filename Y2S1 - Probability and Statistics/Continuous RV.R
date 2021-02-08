# 1
normConstant <- function(f) {
  I = integrate(f, -Inf, Inf)$value
  return(1/I)
}

# 2
verifyPositive <- function(fAux) {
  for (val in seq(-500, 500, 0.1)) {
    if (fAux(val) < 0) F
  }
  T
}

isProbDensity <- function(faux) {
  if(!verifyPositive(faux))
    F
  if (round(integrate(Vectorize(faux), -Inf, Inf)$value, 4) == 1)
    T
  else
    F
}

#3
CRV <- function(pdFuncion) {
  if(!isProbDensity(pdFuncion))
    stop("function is not a probability density")
  object = pdFuncion
  attr(object,"pdf") = pdFuncion 
  #attr(object,"type")= type
  class(object)="CRV"
  return(object)
}

# 4
plotCRV <- function(repartitie, param, x1, x2) {
  domeniu = seq(x1, x2, 0.001)
  if (length(param) == 0) {
    plot(domeniu, repartitie(domeniu), xlab="", ylab="")
  } else if (length(param) == 1) {
    plot(domeniu, repartitie(domeniu, param[1]), xlab="", ylab="")
  } else if (length(param) == 2) {
    plot(domeniu, repartitie(domeniu, param[1], param[2]), xlab="", ylab="")
  } else if (length(param) == 3) {
    plot(domeniu, repartitie(domeniu, param[1], param[2], param[3]), xlab="", ylab="")
  }
}

# 5
expectedValue <- function(X) { # intoarce valoare medie a distributiei
  if(class(X)!="CRV")
    stop("X is not a continuous random variable")
  densityOfX <- attr(X,"pdf")
  integrate(Vectorize(function(x){x*densityOfX(x)}), -Inf, Inf)$value
}

varianceValue<-function(X) {
  if(class(X)!="CRV")
    stop("X is not a continuous random variable")
  densityOfX <- attr(X,"pdf")
  toVariance <- function(x) {
    (x^2)*densityOfX(x)
  }
  integrate(Vectorize(toVariance), -Inf, Inf)$value - (expectedValue(X)^2)
}

moment <- function(X, k) {
  if (k < 1 || k > 4) {
    stop("k nu este corespunzator")
  }
  if (class(X) != "CRV") {
    stop("X nu este v.a. continua")
  }
  tryCatch({
    meanOfFunction(function(x) {x**k}, X)
  }, error = function(e) {
    stop("Nu exista momentul de ordinul dat")
  })
}

centeredMoment <- function(X, k) {
  if (k < 1 || k > 4) {
    stop("k nu este corespunzator")
  }
  if (class(X) != "CRV") {
    stop("X nu este v.a. continua")
  }
  E = expectedValue(X)
  tryCatch({
    meanOfFunction(function(x) {(x-E)**k}, X)
  }, error = function(e) {
    stop("Nu exista momentul de ordinul dat")
  })
}

# 6
meanOfFunction <- function(g, X){ # intoarce valoarea medie a lui g(X)
  if(class(X)!="CRV")
    stop("X is not a continuous random variable")
  densityOfX <- attr(X,"pdf")
  integrate(Vectorize(function(x){x*g(densityOfX(x))}), -Inf, Inf)$value
}

varianceOfFunction <- function(g,X){
  if(class(X)!="CRV")
    stop("X is not a continuous random variable")
  densityOfX <- attr(X,"pdf")
  toVariance <- function(x){
    (x^2)*g(densityOfX(x))
  }
  integrate(Vectorize(toVariance), -Inf, Inf)$value - (expectedValue(X)^2)
}

# 7
PCont<-function(X,a,b){
  if(!class(X)=="CRV")
    stop("X is not a continuous random variable")
  densityOfX = attr(X, "pdf")
  integrate(Vectorize(densityOfX), a, b)
}

# 12
CRVSum = function(X, Y) {
  if(!class(X)=="CRV")
    stop("X is not a continuous random variable")
  if(!class(Y)=="CRV")
    stop("Y is not a continuous random variable")
  densityOfX = attr(X, "pdf")
  densityOfY = attr(Y, "pdf")
  densityOfZ = function(x) {integrate(Vectorize(function(t) {densityOfX(x-t) * densityOfY(t)}), -Inf, Inf)}
  Z = CRV(densityOfX)
  return(Z)
}

CRVDifference = function(X, Y) {
  if(!class(X)=="CRV")
    stop("X is not a continuous random variable")
  if(!class(Y)=="CRV")
    stop("Y is not a continuous random variable")
  densityOfY = attr(Y, "pdf")
  densityOfNegativeY = function(x) {densityOfY(-x)}
  negativeY = CRV(densityOfNegativeY)
  return(CRVSum(X, negativeY))
}