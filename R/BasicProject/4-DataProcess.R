##### 기술 통계량 #####

#min(vec), max(vec)
#range(vec) : 벡터를 대상으로 범위값을 구하는 함수
#mean : 평균 , median(vec) : 중간값
#sum(vec)
#order(vec)
#rank(vec)
#sd(vec), var(vec)
#summary(vec)
#quantile(vec)
#table(vec)
#sample(x,y) : x의 범위에서 y만큼 샘플 데이터를 생성
#str()


## table()
aws<-read.delim("../data/aws_sample.txt", sep="#")
str(aws)
head(aws)
table(aws$AWS_ID)
?table
table(aws$AWS_ID, aws$X., aws$TM)
table(aws[,c("AWS_ID", "X.")])

aws[2500:3100, "X."] = "modified"
table(aws$AWS_ID, aws$X.)


prop.table(table(aws$AWS_ID))
prop.table(table(aws$AWS_ID))*100

paste0(prop.table(table(aws$AWS_ID))*100, '%')

#기술 통계 함수의 모듈화
test<-read.csv("../data/test.csv", header=T)
head(test)
length(test)
data_proc<- function(df){
  for(idx in 1:length(df)){
    cat(idx, "번째 컬럼의 빈도 분석 결과")
    print(table(df[idx]))
    cat("\n")  
  }



  for(idx in 1:length(df)){
    f<-table(df[idx])
    cat(idx, "번째 컬럼의 최대값/최소값 결과 : \t")
    cat("max=", max(f), ", min=", min(f),"\n")
  }
}

data_proc(test)


##### plyr, dplyr #####
#plyr p.193
install.packages("plyr")
library(plyr)

x <- data.frame(id=c(1, 2, 3, 4, 5, 6),height=c(160, 171, 173, 162, 165, 170))
y <- data.frame(id=c(5, 4, 1, 3, 2, 7),weight=c(55, 73, 60, 57, 80, 92))
x
y

#데이터 병합
xy<-join(x, y, by="id", type="left")      #by= 기준키
xy

xy<-join(x, y, by="id", type="right")      
xy

xy<-join(x, y, by="id", type="full")     #full outer join 지원   
xy

xy<-join(x, y, by="id", type="inner")      
xy

#다중 키 
x <- data.frame(key1 =c(1, 1, 2, 2, 3), key2 = c('a','b', 'c', 'd', 'e')
                ,val = c(10,20,30,40,50))
y <- data.frame(key1 =c(3, 2, 2, 1, 1), key2 = c('e','d', 'c', 'b', 'a')
                ,val = c(500,400,300,200,100))
xy <- join(x, y, by=c("key1","key2"))
xy

#기술 통계량 : ddply(), tapply() / tapply는 기본함수
#ddply() 한번에 여러개의 통계치를 구할 때 사용

#taply() 집단 변수를 대상으로 한번에 하나의 통계치를 구할 때 사용(기본함수)
head(iris)
str(iris)
unique(iris$Species)  #Mysql distinct / 중복 제거
class(iris$Species) #level 이 나와있으면 무조건 factor
#각 품종별로 sepal.length의 평균값

tapply(iris$Sepal.Length, iris$Species, mean)  #group by와 비슷
tapply(iris$Sepal.Length, iris$Species, sd) 
#(데이터, 집단변수, 통계치 요약)
ddply(iris, .(Species), summarise, avg=mean(Sepal.Length))
?ddply
ddply(iris, .(Species), summarise, avg=mean(Sepal.Length),
      std=sd(Sepal.Length), max=max(Sepal.Length), min=min(Sepal.Length))



### dplyr
install.packages("dplyr")
library(dplyr)
help(package=dplyr)
#filter() : 특정 행을 추출 -> subset()
#select() : 특정 열을 추출 -> data[, c("열이름","열이름")]
#arrange() : 정렬 -> order(), sort()
#mutate() : 기존의 열에서 새로운 열 추가 -> transform()
#summarize() : 통계치 산출 -> aggregate()
#groupby() : 집단별로 나누기 -> subset(), tapply(),aggregate()
#left_join() : 데이터 합치기(열을 기준) -> cbind()
#bind_rows() : 데이터 합치기(행을 기준) -> rbind()

exam<-read.csv("../data/csv_exam.csv")
exam

##filter
# 1반 학생들의 데이터를 추출
exam[exam$class==1, ]
filter(exam, class==1) #(데이터, 조건)
exam %>% filter(class==1) # %>%해야될일들을 순차적으로 세울 수 있는 코드

# 2반이면서 영어점수가 80이상인 데이터 추출
exam %>% filter(class==2 & english >= 80)
exam[exam$class==2 & exam$english>=80,]
# 1, 3, 5반에 해당하는 데이터를 추출
exam %>% filter(class %in% c(1,3,5))
exam %>% filter(class==1|class==3|class==5)

##select()
#수학점수만 추출
exam[,3]
exam %>% select(math)

# 반, 수학, 영어점수만 추출
exam %>% select(class, math, english) 

# 수학점수를 제와한 나머지
exam %>% select(-math)

## filter + select
#1반 학생들의 수학점수만 추출
exam %>% filter(class==1) %>% select(math) %>% head(2)

## arrange 기본적으로 오름차순
exam %>% arrange(math)
exam %>% arrange(desc(math)) #내림차순
exam %>% arrange(class, math)


## mutate
exam$sum <- exam$math + exam$english + exam$science
exam

exam<-exam[, -6]
exam

exam<-exam %>% mutate(sum=math+english+science, mean=(math+english+science)/3)
exam

## summarize() 요약할때 컬럼은 직접 하나 만들어야한다.
exam %>% summarise(mean_math=mean(math))

## group_by()
exam %>% group_by(class) %>% 
  summarise(mean_math=mean(math), sum_math=sum(math), 
            median_math=median(math), n=n())

## left_join(), bind_rows()
test1 <- data.frame(id=c(1, 2, 3, 4, 5), midterm=c(60, 70, 80, 90, 85))
test2 <- data.frame(id=c(1, 2, 3, 4, 5), midterm=c(70, 83, 65, 95, 80))

total <- left_join(test1, test2, by="id")
total

group_all <- bind_rows(test1, test2)
group_all


#연습 문제
install.packages("ggplot2")
library(ggplot2)
#자동차 연비와 관련된 데이터 
#displ:배기량 / cyl:실린더개수/cty:도시연비/hwy:고속도로연비
str(ggplot2::mpg)

head(ggplot2::mpg,10)
class(ggplot2::mpg)
str(ggplot2::mpg)
mpg<- as.data.frame(ggplot2::mpg)
head(mpg)
data(mpg)
class(mpg)
tail(mpg)
names(mpg)
dim(mpg)
View(mpg)

# 배기량(displ)이 4이하인 차량의 모델명, 배기량, 생산년도 조회
mpg %>% filter(displ<=4) %>% select (model, displ, year)

# 통합연비 파생변수(total)를 만들고 통합연비로 내림차순 정렬을 한 후에 3개의 행만 선택해서 조회
# 통합연비 : total <- (cty + hwy)/2
mpg$total<-(mpg$cty+mpg$hwy)/2
mpg %>% arrange(desc(total)) %>% head(3)
#mpg_a<-mpg %>% (total=(Cty+why)/2)      원본이 훼손되지 않게 새로운 데이터를 만들어서 저장
#mpg_a %>% arrange(desc(total)) %>% head(3)


# 회사별로 "suv"차량의 도시 및 고속도로 통합연비 평균을 구해 내림차순으로 정렬하고 1위~5위까지 조회
mpg %>% group_by(manufacturer) %>% filter(class=="suv") %>% 
  summarise(mean_total=mean(total)) %>% arrange(desc(mean_total))  %>% head(5)

# 어떤 회사의 hwy연비가 가장 높은지 알아보려고 한다. hwy평균이 가장 높은 회사 세곳을 조회
mpg %>% group_by(manufacturer) %>% summarise(mean_hwy=mean(hwy)) %>% arrange(desc(mean_hwy)) %>% head(3)

# 어떤 회사에서 compact(경차) 차종을 가장 많이 생산하는지 알아보려고 한다. 각 회사별 경차 차종 수를 내림차순으로 조회
mpg %>% group_by(manufacturer) %>% filter(class=="compact") %>% summarise(n=n()) %>% arrange(desc(n))

# 연료별 가격을 구해서 새로운 데이터프레임(fuel)으로 만든 후 기존 데이터셋과 병합하여 출력.
# c:CNG = 2.35, d:Disel = 2.38, e:Ethanol = 2.11, p:Premium = 2.76, r:Regular = 2.22
# unique(mpg$fl)
fuel<- data.frame(fl=c("c", "d", "e", "p", "r"), fule=c(2.35, 2.38, 2.11, 2.76, 2.22))
unique(mpg$fl)
mpg <- left_join(mpg, fuel, by="fl")
mpg

# 통합연비의 기준치를 통해 합격(pass)/불합격(fail)을 부여하는 test라는 이름의 파생변수를 생성. 이 때 기준은 20으로 한다.
mpg$test<-ifelse(mpg$total>=20,"pass","fail")

head(mpg)
# test에 대해 합격과 불합격을 받은 자동차가 각각 몇대인가?

table(mpg$test)


# 통합연비등급을 A, B, C 세 등급으로 나누는 파생변수 추가:grade
# 30이상이면 A, 20~29는 B, 20미만이면 C등급으로 분류
mpg_B <- mpg %>% mutate(grade=ifelse(total>=30, "A", ifelse(total>=20,"B","C")))
mpg_B
View(mpg_B)
table(mpg_B$grade)

### 연습문제 2
#미국 동북부 437개 지역 인구 통계 정보
midwest <- as.data.frame(ggplot2::midwest)
str(midwest)
View(midwest)
names(midwest)

head(midwest)

# 전체 인구대비 미성년 인구 백분율(ratio_child) 변수를 추가
midwest_a <- midwest %>% mutate(ratio_child=(poptotal-popadults)/poptotal*100)
View(midwest_a)
# 미성년 인구 백분율이 가장 높은 상위 5개 지역(county)의 미성년 인구 백분율 출력
midwest_a %>% arrange(desc(ratio_child)) %>% head(5)

# 분류표의 기준에 따라 미성년 비율 등급 변수(grade)를 추가하고, 각 등급에 몇개의 지역이 있는지 조회
# 미성년 인구 백분율이 40이상이면 "large", 30이상이면 "middel", 그렇지않으면 "small"
midwest_a <- midwest_a %>% mutate(grade=ifelse(ratio_child>=40, "large", 
                                               ifelse(ratio_child >= 30, "middel", "small"))) 
table(midwest_a$grade)
View(midwest_a)
# 전체 인구 대비 아시아인 인구 백분율(ratio_asian) 변수를 추가하고 하위 10개 지역의 state, county, 아시아인 인구 백분율을 출력
midwest_a <- midwest_a %>% mutate(ratio_asian=popasian/poptotal*100)
midwest_a %>% arrange(ratio_asian) %>% select(state, county, ratio_asian) %>% head(10) 

##### 데이터 전처리 Data Preprocessing#####
## 순서 : 데이터 탐색 (탐색적 데이터 분석) -> 결측치 처리 -> 이상치 처리 -> Feature Engineering
# 데이터 탐색 : 필드의 특성, 개수, 의미......./데이터를 파악해야 뭘처리할지 어떻게 처리할지   
# 1) 변수 확인
# 2) 변수 유형데이터 형식(범주형, 연속형, 문자형, 숫자형, ....) >통계 기반이 달라진다
# 3) 변수의 통계량 : 평균, 최빈값, 중간값, 분포,....
# 4) 관계, 차이 검정 (통계기반 검정)

#결측치 처리 : 빠진 데이터가 없는지 확인 / 가장 필수적인 처리
# 1) 삭제
# 2) 다른 값으로 대체 (평균, 최빈값, 중간값,....)
# 3) 예측값 : 선형회귀분석, 로지스틱 회귀분석

# 이상치 처리
# 1) 이상치 탐색 - 시각적 확인 : 산포도(scatter plot), box plot
#                - 통계적 확인 : 표준 잔차, leverage, Cook's D
# 2) 처리 방법
#                - 삭제
#                - 다른 값으로 대체
#                - 리샘플링(케이스별로 분리)

# Feature Engineering
# 1) Scaling : 단위 변경
# 2) Binning : 연속형 변수를 범주형 변수로 변환
# 3) Dummy : 범주형 변수를 연속형 변수로 변환
# 4) Transform : 기존 존재하는 변수의 성질을 이용해 다른 변수를 만드는 방법

### 변수명 바꾸기
df_raw <- data.frame(var1=c(1,2,3), var2=c(2,3,2))
df_raw
#기본(내장)함수
df_raw1<- df_raw
names(df_raw1) <- c("v1","v2")
df_raw1


# dplyr
df_raw2 <- df_raw
df_raw2 <- rename(df_raw2, v1=var1, v2=var2)
df_raw2


### 결측치 처리 
dataset1 <- read.csv("../data/dataset.csv", header=T)
str(dataset1)
head(dataset1)
View(dataset1)


#resident : 1~5까지의 값을 갖는 명목변수로 거주지를 나타냄 
#gender : 1~2까지의 값을 갖는 명복면수로 남/녀를 나타냄
# job : 1~3까지의 값을 갖는 명목변수. 직업을 나타냄
# age : 양적변수(비율) : 2~69
# position : 1~5까지의 값을 갖는 명목변수. 직위를 나타냄
# price : 양적변수(비율) : 2.1 ~ 7.9
# survey : 만족도 조사 : 1~5까지 명목변수

y<- dataset1$price
plot(y)
attach(dataset1)  #계속 쓰면 attach를 쓰는것이 좋다
plot(price)
detach(dataset1)  #detach는 attach를 끝내는 것
plot(price)

#결측치 확인 
summary(dataset1$price) #NA's 결측치 갯수

#결측치 제거
sum(dataset1$price) #결측치가 있어서 계산 불가
sum(dataset1$price, na.rm=T) #결측치를 빼고 계산(완전한 제거 X)

price2 <- na.omit(dataset1$price) #omit은 데이터를 완전히 삭제
summary(price2)
sum(price2)

# 결측치를 대체
price3 <- ifelse(is.na(dataset1$price), 0, dataset1$price)
summary(price3)

# 결측치 대체  평균으로 대체
price4 <- ifelse(is.na(dataset1$price), round(mean(dataset1$price, na.rm=T),2), 
                 dataset1$price)
summary(price4)

### 이상치 처리
#색깔(질적), 무게(양), 소프트웨어 버전(질적), 자동차 년식(질적)
#부채비율(양)

#질적 자료(수차기아닌 명목형, 서열형): 도수분포표, 분할표 
#> 막대그래프(빈도수), 막대도표(%), 원도표
names(dataset1)
table(dataset1$gender)
pie(table(dataset1$gender))



#양적 자료(이산변수, 연속변수) : 산술평균, 중앙값, 조화평균 > 히스토그램, 상자도표, 시계열도표, 산포도

summary(dataset1$price) #최소값과 최대값이 평균과 너무 큰 차이가 난다.
length(dataset1$price)
str(dataset1)
plot(dataset1$price)
boxplot(dataset1$price)

#이상치 처리
dataset2 <- subset(dataset1, price>=2 & price <=8)
length(dataset2$price)
plot(dataset2$price)
boxplot(dataset2$price)

summary(dataset2$age)
plot(dataset2$age)
boxplot(dataset2$age)

### Feature Enginnering
View(dataset2)

# 가독성을 위한 데이터 변경 
dataset2$resident2[dataset2$resident == 1] <- "1.서울특별시" #데이터 접근
dataset2$resident2[dataset2$resident == 2] <- "2.인천광역시"
dataset2$resident2[dataset2$resident == 3] <- "3.대전광역시"
dataset2$resident2[dataset2$resident == 4] <- "4.대구광역시"
dataset2$resident2[dataset2$resident == 5] <- "5.시구군"
View(dataset2)

# 척도 변경 : Binning (범주로 묶어서)
# 나이변수를 청년층(30세 이하), 중년층(31~51세), 장년층(56세 이상)

dataset2$age2[dataset2$age<=30] <- "청년층"
dataset2$age2[dataset2$age>30 & dataset2$age <= 55 ] <- "중년층"
dataset2$age2[dataset2$age>56] <- "장년층"
View(dataset2)

# 역코딩 (숫자의 가중치를 바꿀 때 ex)1이 제일크게 5가 제일 작게)

table(dataset2$survey)

t_survey <- dataset2$survey
t_survey

c_survey <- 6-t_survey 
dataset2$survey <- c_survey
View(dataset2)

# Dummy 데이터 처리 
# 거주유형 : 단독주택(1), 다가구주택(2), 아파트(3), 오피스텔(4)
# 직업유형 : 자영업(1), 사무직(2), 서비스(3), 전문직(4), 기타(5)
user_data <- read.csv("../data/user_data.csv", header=T)
View(user_data)

table(user_data$house_type)
#house_type2 컬럼을 새로 추가하여 단독주택과 다가구는 0으로 아파트와 오피스텔은 1로 변환 
user_data$house_type2[user_data$house_type == 1 | user_data$house_type ==2]<- 0
user_data$house_type2[user_data$house_type == 3 | user_data$house_type ==4]<- 1
View(user_data)

house_type2 <- ifelse(user_data$house_type==1|user_data$house_type==2,0,1)
user_data$house_type<-house_type2
table(user_data$house_type2)

# 데이터 구조 변경(wide type, long type) : melt():long으로 변경, cast():wide로 변경
#서로다른 값들이 종단으로 쭉 길게 이어나가는 것을 long type
#횡으로 나열하는 경우에는 wide type 

#reshape, reshape2, tidyr,.....
install.packages("reshape2") #와이드형 데이터
library(reshape2)

str(airquality)
head(airquality)
ml <- melt(airquality, id.vars=c("Month", "Day"))
View(ml)
m2 <- melt(airquality, id.vars=c("Month", "Day"), variable.name = "climate_var",
           value.name = "climate_val")
View(m2)
m3 <- melt(airquality, id.vars=c("Month", "Day"), variable.name = "climate_var",
           value.name = "climate_val", na.rm=T)
View(m3)

?dcast
dc1<- dcast(m2, Month + Day ~ climate_var)
View(dc1)


data <- read.csv("../data/data.csv", header=T)
View(data)



#날짜별로 컬럼을 생성하여 wide하게 변경
data1 <- dcast(data, Customer_ID ~ Date)
View(data1)
#바꾼것을 다시 롱형으로 
data2 <- melt(data1, id.vars=c("Customer_ID","Buy"), variable.name = "Date", na.rm = T)
View(data2)



pay_data <- read.csv("../data/pay_data.csv", header=T)
View(pay_data)

#product_type을 와이드하게 변경
pay_data1 <- dcast(pay_data, user_id + pay_method + price ~ product_type)
View(pay_data1)

pay_data1 <- dcast(pay_data, user_id ~ product_type)
View(pay_data1)


pay_data2 <- melt(pay_data1, id.vars=c("user_id","pay_method","price"), na.rm=T)
View(pay_data2)


##### MYSQL과 연동 #####
install.packages("rJava")
install.packages("DBI")
install.packages("RMySQL")
library(RMySQL)

# create database rtest;
# use rtest
# create table score (
#  student_no varchar(50) primary key,
#  kor int default 0,
#  eng int default 0,
#  mat int default 0
# );

# insert into score(student_no, kor, eng, mat) values('1', 90, 80, 70);
# insert into score(student_no, kor, eng, mat) values('2', 90, 88, 70);
# insert into score(student_no, kor, eng, mat) values('3', 90, 89, 70);
# insert into score(student_no, kor, eng, mat) values('4', 90, 87, 70);
# insert into score(student_no, kor, eng, mat) values('5', 90, 60, 70);

conn <- dbConnect(MySQL(), dbname="rtest", user="root",password="1111", host="127.0.0.1")
conn

dbListTables(conn) #show tables 와 같은 함수
result<-dbGetQuery(conn, "select count(*)from score")
result

dbListFields(conn, "score") #desc tables명;

#DML을 쓸때 (insert, update, delete)
dbSendQuery(conn, "delete from score where student_no = 1")
result<-dbGetQuery(conn, "select count(*)from score")
result

#파일로부터 데이터를 읽어들여 DB에 저장
#같은 이름의 테이블이 있다면 에러
dbSendQuery(conn, "drop table score")
dbListTables(conn)
file_score <- read.csv("../data/score.csv", header=T)
file_score

result<-dbGetQuery(conn, "select *from score")
result

dbDisconnect(conn)

detach("package:RMySQL", unload=T)

### sqldf : R + SQL  / SQL문법을 R에서 쓸수 있게 해주는것(DB연결과는 관련이 없다.)
install.packages("sqldf")
library(sqldf)

head(iris)
sqldf("select * from iris limit 6")
sqldf("select * from iris order by Species desc limit 10")

sqldf('select sum("sepal.Length") from iris')


unique(iris$Species)
sqldf("select distinct species from iris")

table(iris$Species)
sqldf("select species, count(*) from iris group by species ")



