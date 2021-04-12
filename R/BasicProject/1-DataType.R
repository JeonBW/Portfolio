##### 변수(메모리장소) #####

goods = "냉장고"
goods


# R도 모든것이 객체(객체 기반 언어)
# 변수 사용시 객체형태로 사용하는 것을 권장한다.
goods.name = "냉장고"
goods.code = "ref001"
goods.price = 600000

goods.name

# R에서 값을 대입할때에는 =보다는 <-  사용 (=는 제한적으로 사용)
goods.name <- "냉장고"
goods.code <- "ref001"
goods.price <- 600000
goods.code

# 데이터 타입 확인
class(goods.name)
class(goods.price)
mode(goods.name)
mode(goods.price)

# 도움말 활용

help(sum)     
?sum
args(sum)  
example(sum)  
  
  
##### 데이터 타입  #####

#*배열*
#*---
#*1) 같은 형식끼리 묶어준다.
#*2) 크기가 정해져있다.
#*3) 삽입, 삭제가 불편하다.(연속적으로 데이터를 저장해야 하기 때문에 
#중간에 삭제하면 비어버리기 때문에 뒤에있는 데이터를 다 땡겨줘야한다.)




# 스칼라 : 하나의 값 (0차원) (가장 작은 단위 / 파이썬의 기본 데이터 타입)
# *숫자, 문자열, 불린(boolean), 팩터, NA, NULL
# * 기본 자료형 : numeric, character,logical, factor
# * 특수 자료형 : NA, NULL, NaN(Not a number/숫자가 아닌), Inf(무한대)


#벡터(Vector) : 1차원 (파이썬의 list, set, dict, tuple.....) 배열의 개념
# R에서 가장 기본적인 데이터 타입
# 리스트에는 여러가지 데이터 타입의 데이터가 들어갈 수 있지만 
# 배열은 하나의 데아터 타입만 들어가수 있다.

# 행렬(Matrix): 2차원 (배열의 개념)  
# 데이터 프레임(DataFrame) : 2차원

# 배열(Array) :  3차원 이상의 데이터를 다룰 때
# 리스트(List) : 3차원 이상을 다룰때   
  
# Vector
#1) R에서 사용하는 기본 자료 구조
#2) 1차원 *배열*(같은 형식의 데이터들끼리만 묶어야 한다.)
#3) 인덱스로 접글할 수 있다. 
#4) 동일한 자료형만 저장할 수있다.
#5) c(), seq(), rep()      c는 combine의 약자

v<-c(1, 2, 3, 4, 5)
v
class(v)
mode(v)
#()로 담으면 print효과가 있어 그자리에서 바로 출력까지 가능하다
(v<-c(1, 2, 3, 4, 5))
#범위 지정
c(1:5)
mode(c(1:5))

# 서로다른 데이터타입을 넣으면 같은자료형으로 바뀐다. 
c(1, 2, 3, 4, "5")
mode(c(1, 2, 3, 4, "5"))

#seq() 일련번호/순서있는 데이터를 순서대로 가져올 때 (시작, 끝, 간격)
?seq
(seq(from=1, to=10, by=2))
(seq(1, 10, 2))

#rep() 반복해서 무언가를 만들어주는 함수 
(rep(1:3, 3))
(rep(1, 3))

# 벡터의 접근 . 인덱스  (R은 0이 아닌 1부터 시작)
#[]는 접근 (생성x)
a <- c(1: 50)
a[10:45]
length(a)
a[10:(length(a)-5)]
# 10부터 50까지에서 각각 5씩 빼준다/ 항상 괄호를 주의!
a[10:length(a)-5]

b <- c(13, -5, 20:23, 12, -2:3)
b
b[1]
b[c(2,4)]
b[c(4, 5 : 8, 7)]
#제외하고 나머지 출력
b[-1]
b[-2]
b[-c(2,4)]
b[-c(4, 5:8, 7)]

#벡터를 가지고 연산한다는 의미는 집합 연산(합집합 교집합 차집합)
x <- c(1, 3, 5, 7)
y <- c(3,5)
#합집합
union(x,y)
#차집합
setdiff(x,y)
#교집합
intersect(x,y)
#R에서 ;는 문장의 끝을 의미
union(x,y); setdiff(x,y); intersect(x,y)

identical(x, y)
setequal(x, y)

#컬럼명 지정
age <- c(30, 35, 40)
names(age) <- c("홍길동", "임꺽정", "신돌석")
age

# 특정 변수의 데이터 삭제(environment의 빗자루는 전체데이터 삭제)
age <- NULL
age

#벡터 생성의 또 다른 표현(범위를 지정할떄 C를 안붙혀도 된다.)
x <- c(2,3)
x <- (2:3) 
x

##### 팩터 #####

# 범주형 데이터 타입
# 데이터를 따질 때 숫자냐 범주냐 

#중복된 값이 여러개가 들어가면 묶을 수 있다. -> 범주가 발생 ->팩터형으로 바꿀 수있다 
gender <- c("man", "woman", "woman", "man", "man")
gender
class(gender)
mode(gender)
is.factor(gender)
is.vector(gender)
plot(gender)
#as는 데이터 형식을 바꿀때, is 무엇인가를 확인할 때
#factor일때는 levels로 나타난다.
ngender <- as.factor(gender)
ngender
class(ngender)
is.factor(ngender)

# 팩터는 빈도수이기 때문에 mode로 확인하면 항상 numeric 
mode(ngender)

#특정 클래스에 대한 타입을 확인할때는 class,
#데이터의 타입 mode
#기본 그래프로 나타나게하는 함수 plot
plot(ngender)

#팩터로 바꿔줄 수 있는 것은 바꿔주는 것이 편리하다.
#도수분포표 table()
table(ngender)

#강제로 팩터를 만드는 함수 (백터데이터, 범주, 정렬)
?factor
ofactor <- factor(gender, levels=c("woman", "man"), ordered=TRUE)
ofactor










##### 행렬 #####
# 1) 행과 열의 2차원 배열(벡터를 가로 세로로)
# 2) 동일한 데이터 타입만 저장 가능
# 3) matrix(), rbind(), cbind()

m <- matrix(c(1:5))
m

# 데이터는 열방향으로 채워준다.
m <- matrix(c(1:11), nrow=2)
m


#데이터를 행방향으로
m <- matrix(c(1:11), nrow=2, byrow=TRUE)
m

class(m)
mode(m)

#rbind(), cbind()
x1 <- c(3, 4, 50:52)
x2 <- c(30, 5, 6:8, 7, 8)
x1
x2

mr<- rbind(x1, x2)
mr

mc<- cbind(x1, x2)
mc

# matrix 차수 확인
X <- matrix(c(1:9), ncol=3)
X
length(X)
nrow(x)    #행의 갯수 
ncol(x)    #열의 갯수
dim(x)

#컬럼명 지정
colnames(x) <- c("one", "two", "three")
x
colnames(x)

#apply (파이썬에서의 map함수)
?apply #(데이터, 행(1)열(2), 함수주소)
apply(x, 1, max) #행별로 가장 큰 값
apply(x, 2, max) #열 별로 가장 큰 값
apply(x, 1, sum)
apply(x, 2, sum)
apply(x, 1, mean)
apply(x, 2, mean)

#행렬 데이터 접근(인덱스가 두개 들어간다.)[행, 열]
x[1, 2]
aws = read.delim("../data/AWS_sample.txt", sep="#")
head(aws)
(aws[1,1])
x1 <- aws[1:3, 2:4]
x1
#x2 <- aws[9:11, ]  #생략하면 전체를 가져온다
#x2
x2 <- aws[9:11, 2:4]
x2
class(x2)

cbind(x1, x2)
rbind(x1, x2)



##### 데이터 프레임 data.frame #####
# 1) DB의 table과 유사 (사람이 제일 쓰기 편한 데이터 형태)
# 2) R에서 가장 많이 사용되는 구조
# 3) 컬럼 단위로 서로 다른 데이터 타입 사용 가능 
# 4) data.Frame(), read.csv(), read.delim(), read.table(), ......

no <- c(1, 2, 3)
name <- c("hong", "lee", "kim")
pay <- c(150, 250, 300)
#data.frame(컬림이름지정)
emp <-data.frame(No=no, Name=name, Payment=pay)
emp

#read.csv(), read.table()
getwd() #현재 작업하고 있는 폴더위치
setwd("../data") #작업하는 위치 변경
getwd()
txtemp <- read.table("emp.txt", header=T, sep=" ") #첫번째 줄을 제목으로 처리 header=T
txtemp
class(txtemp)
mode(txtemp)

csvemp <- read.csv("emp.csv") #따로 ,구분자를 쓸 필요가 없다.
csvemp
class(csvemp)
mode(csvemp)
#R에서는 여러개를 묶을때 항상 벡터!!/ header = T ,sep=","가 디폴트값 
csvemp1 <- read.csv("emp.csv",col.names=c("사번","이름","급여")) 
csvemp1
class(csvemp1)
mode(csvemp1)

#제목이 없으면 첫 번째 레코드를 제목으로 처리 
csvemp2 <- read.csv("emp2.csv", header=F, col.names=c("사번","이름","급여"))
csvemp2

#콘솔이 아니라 새창에서 볼 때 View()
View(csvemp2)

#접근
#csvemp2[,1] 
csvemp2$사번         #열이름으로 접근할 수 있다.
class(csvemp2$사번) #숫자형이라는 것은 하나의 열이 벡터형 이라는 뜻

#데이터프레임 구조 확인(어떻게 구성되어 있는가)
str(csvemp2)  #mysql desc 테이블명; 과 비슷

#기본 통계량 확인
summary(csvemp2)

#apply
df <- data.frame(x=c(1:5), y=seq(2, 10, 2), z=c("a","b","c","d","e"))
df

apply(df[,c(1,2)],2 ,sum)
apply(df[,c(1,2)],1 ,sum)
?apply

# 데이터의 일부 추출
x1 <- subset(df, x>=3)
x1

x2 <- subset(df, X>=2 & y<=6)
x2

#병합 
height<-data.frame(id=c(1,2), h=c(180, 175))
weight<-data.frame(id=c(1,2), w=c(80, 75))

#서로 공통된 필드를 가지고 관련있는 데이터를 묶어줄 수 있다.
user <- merge(height, weight, by.x ="id", by.y="id")
user
















##### 배열 Array #####
# 1) 행, 열, 면의 3차원 배열 형태의 객체 생성
# 2) array()
# 3) 같은 데이터타입만 가능하다.
# 4) 차원이라는 것은 계속 합쳐나가는 것
v <- c(1:12)
arr <- array(v, c(3, 2, 3))
arr

# 접근 
arr[,,1]
arr[,,2]
#5 추출
arr[2,2,3]
arr[2,2,1]

#8 추출
arr[2,1,2]






##### 리스트 list #####
# 파이썬의 리스트와 헷갈리지 않도록 주의
# 1) key와 Value를 한쌍
# 2) python에서의 dict와 유사
# 3) list()

x1<-1  #스칼라
x2<-data.frame(var1=c(1,2,3), var2=c('a','b','c')) #데이터 프레임
x3<-matrix(c(1:12),ncol=2)
x4<-array(1:20, dim=c(2,5,2))

x5<-list(c1=x1, c2=x2, c3=x3, c4=x4) #c1,c2,...하나의 면
x5

x5$c1
x5$c2

list1 <- list("lee", "이순신", 9)
list1

list1[1]    #컬럼 이름이 없을 때
list1[[1]]
list1[2]
list1[[2]]

un<-unlist(list1)
un
class(un)

#apply : lapply(), sapply()
#apply는 2차원 이상의 데이터만 입력을 받는다. 
#lapply() vector를 입력받기 위한 방법으로 사용, 반환형(return값)은 list형이다.
#sapply() 반환형이 행렬 또는 vector로 반환(lappy의 wrapper)
a<-list(c(1:5))
b<-list(c(6:10))
a
b

c<-c(a,b) #두개의 리스트데이터를 벡터로 묶은 것 
c
class(c)

#appy
x<-lapply(c, max)
x
class(x)
x1<-unlist(x)
x1
y<-sapply(c,max)
y

##### 기타 데이터 타입 #####
# 날짜 
# 현재날짜
Sys.Date()
# 현재 시간
Sys.time()

a<- "20/11/27"
a
class(a)
b<-as.Date(a) 
b
class(b)

c<-as.Date(a, "%y/%m/%d")
c





