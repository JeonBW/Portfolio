##### 조건문 #####

#난수 준비
x<-runif(1) #0~1까지의 균일 분포에서 데이터를 랜덤하게 뽑아주는 함수
?runif
x

# x가 0보다 크면 절대값(abs())으로 값을 출력 
if (x > 0){
  print(abs(x))
}

# x가 0.5보다 작으면 1-x를 출력하고  그렇지 않으면 x 를 출력
if (x < 0.5){
  print(1-x)
}else{                   #else를 쓸 때 if와 같이 묶일수 있도록 줄바꿈하지 않아야 한다.
  print(x)
}

if (x<0.5) print(1-x) else print(x) #처리할 문장이 한문장이면 한줄로 쭉 써도 된다.
#ifelse
ifelse(x<0.5,1-x,x)

#다중 조건
avg<-scan()

if(avg>=90){
  print("당신의 학점은 A입니다.")
} else if(avg>=80){
  print("당신의 학점은 B입니다.")
} else if (avg>=70){
  print("당신의 학점은 C입니다.")
} else if (avg>=60){
  print("당신의 학점은 D입니다.")
} else{
  print("당신의 학점은 F입니다.")
}



#switch(비교문, 실행문, 실행문,......) switch는 무조건 같다라는 조건만 사용 가능
a<-"중1"
switch(a, "중1"=print("14살"), "중2"=print("15살"))
switch(a, "중1"=("14살"), "중2"=("15살"))
b<-3          #따로 케이스가 없으면 인덱스
switch(b, "14살","15살","16살")

empname<-scan(what="")
switch(empname, hong=250, lee=350, kim=200, kang=400)
#좌변에는 항상 문자열
avg<-scan()%/% 10
result<-switch(as.character(avg), "10" = "A", "9" ="A", "8" ="B", "7"="C", "6"="D", "F")
cat("당신의 학점은", result, "입니다.")

#which() p.171
x <- c(2:10)
x 

which(x==3) #벡터안의 3이라는 값이 있는가, which는 위치를 알려주는 함수
x[which(x==3)] 

m <- matrix(1:12, 3, 4)
m

which(m%%3 == 0)    #벡터처럼
?which #arr.ind=F   배열에서 인덱스를 쓸 수 있게 할 것인가 
which(m%%3 == 0, arr.ind = T) #행과 열로 위치값을 알려주는

no <- c(1:5)
name <- c ("홍길동", "유비", "관우", "장비", "조자룡")
score <- c(85, 78, 89, 90, 74)
exam <-data.frame(학번=no, 이름=name, 성적=score)
exam
which(exam$이름 == "장비")  # $로 접근
exam[which(exam$이름 == "장비"),]
#가장 높은 점수를 가진 학생은?
which.max(exam$성적)
which.min(exam$성적)
exam[which.max(exam$성적),]
exam[which.min(exam$성적),]

# any(), all
?any
?all
x<-runif(5)
x
# x 중에서 0.8이상이(한개라도) 있는가?
any(x>=0.8)
# x 의 값이 0.9 이하인가 ?
all(x<=0.9)



##### 반복문 #####
sum <- 0
for (i in seq(1, 10, by=1)){
  sum<-sum+i
}
sum

sum <- 0
for (i in c(1:10)) sum<-sum+i       #한 줄일 경우 중괄호 생략 가능
sum



sum <-1
while(sum<=10){
  print(sum)
  sum<-sum+1
}
sum

##### 함수 ######
# 인자 없는 함수
test1 <- function(){
  x<-10
  y<-10
  #return(x*y)
  x*y
}
test1()

test2<- function(x,y){
  a=x
  b=y
  return(sum(a,b))
}
test2(10,20)
test2(y=20, x=10)

#가변 인수 : ...
test3 <- function(...){
  #print(list(...))
  for(i in list(...)) print(i)
}
test3(10)
test3(10,20)
test3(10,20,30)
test3('3', "홍길동", 10)

test4 <- function(a, b, ...){
  print(a)
  print(b)
  print("--------------")
  test3(...)
}
test4(10, 20, 30, 40)

##### 문자열 함수 #####

# stringr : 정규 표현식 활용
install.packages("stringr")
library(stringr) #require(stringr)

str1<-"홍길동35이순신45임꺽정25"
str_extract(str1, "\\d{2}")     #숫자 두자리가 반복되는 것을 뽑아내는
str_extract_all(str1, "\\d{2}")
str_extract_all(str1, "[1-9]{2}")
class(str_extract_all(str1, "[1-9]{2}"))

str2<-"hongkd105leess1002you25TOm400강감찬2005"
#3자리 문자
str_extract_all(str2, "[a-zA-z가-힣]{3}" )
str_extract_all(str2, "[a-zA-z가-힣]{3,}" )

str_length(str2)
length(str2)
str_locate(str2, "강감찬")
str_c(str2, "유비55") #실제 변수에 값이 추가되는 것은 아니다.
str2
str3<-"hongkd105,leess1002,you25,TOm400,강감찬2005"
str_split(str3, ",")
#기본 함수 
sample <- data.frame(c1 = c("abc_abcdefg", "abc_ABCDE","ccd"), c2=1:3)
sample
nchar(sample[1,1])
which(sample[,1]=="ccd")
toupper(sample[1,1])
substr(sample[,1],start=1, stop=2)

install.packages("splitstackshape")
library(splitstackshape)

cSplit(sample, splitCols="c1", sep="_")
#기본함수
paste0(sample[,1],sample[,2]) #1열과 2열에 있는것을 합치는
paste(sample[,1],sample[,2],sep="@@")
