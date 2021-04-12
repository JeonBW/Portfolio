### 조건 p.335
# 1. Chi-square Test : 데이터가 수가 충분할 때 (정규분포임을 전제로 한다.->모수적 통계방법을 사용)
# 2. Fisher's exact test : 데이터 수가 부족할 때 
# 3. Cochran-armitage trend test : 명목변수가 서열변수일때(trend가 있을 때)
# 일원 카이제곱(차이 검정), 이원 카이제곱(관계 검정)
# 기준값보다 작은 셀이 20%이하면 데이터 수가 충분하다  크면 불충분
# 레이블이 의미가 있거나 서열이 있는 경우 Cochran-armitage trend test



##### 실습 1 #####

View(mtcars)
class(mtcars)
# 자동차의 실린더 수와 변속기의 관계 
table(mtcars$cyl, mtcars$am)

# 가독성을 위해서 테이블 수정 (전처리)
mtcars$tm <- ifelse(mtcars$am == 0, "auto", "manual")
result <- table(mtcars$cyl, mtcars$tm)
result
barplot(result)
# auto의 눈금이 벗어났기 때문에 최대값을 알 수 없음 -> 눈금조정
barplot(result, ylim=c(0,20))

# 범례 추가
barplot(result, ylim=c(0,20),legend=rownames(result))

# 범례 형식
barplot(result, ylim=c(0,20),legend=paste(rownames(result),"cyl"))
#mylegend=paste(rownames(result),"cyl")
#barplot(result, ylim=c(0,20), legend=mylegend)

# 그래프를 수직으로 나누기
barplot(result, ylim=c(0,20), legend=mylegend, beside=T)

# 그래프를 수평으로 
barplot(result, ylim=c(0,20), legend=mylegend, beside=T, horiz=T)

#색상
mycol=c("tan1", "coral2","firebrick2")
barplot(result, ylim=c(0,20), legend=mylegend, beside=T, horiz=T,col=mycol)

#카이그래프를 가장 잘 시각화 할 수 있는 그래프는 막대 그래프

### 카이 제곱 검정
result

# 결과 합을 구할 때 
addmargins(result)


chisq.test(result)
#p-value만 봤을때는 차이가 있다. -> 관계가 있다.
#경고메세지 : 데이터가 충분하지 않기 때문에 정확하지 않을 수 있다-> 믿을 수 없다
#따라서 fisher.test를 사용

fisher.test(result)
#실런더 개수와 변속기 사이에는 관계가 있다.


##### 실습 2 #####
mydata <- read.csv("../data/anova_two_way.csv", header = T)
View(mydata)

# ad_layer와 multichild와의 관계 시군구에 따라 지원조례가 차이가 있는지

# 시군구(ad_layer)와 다가구지원조례(multichild)가 관계가 있는지
result <- table(mydata$ad_layer, mydata$multichild)
result
chisq.test(result)
fisher.test(result)
# 서로 관계가 없다 = 시군구를 따지지 않고 시행하고 있다.

##### 실습 3 #####
library(foreign)
library(dplyr)
library(ggplot2)
library(readxl)
welfare <- read.spss(file="../data/Koweps_hpc10_2015_beta1.sav", to.data.frame=T)

welfare <- rename(welfare, sex=h10_g3, birth=h10_g4, marriage=h10_g10,
                  religion=h10_g11, income=p1002_8aq1, code_job=h10_eco9,
                  code_region=h10_reg7)

welfare <- welfare[, c("sex","birth","marriage","religion","income",
                       "code_job", "code_region")]
View(welfare)

#성별과 종교의 관련성 여부
sr <- table(welfare$sex, welfare$religion)
sr
welfare$sex1 <- ifelse(welfare$sex == 1, "male", "female")
welfare$religion1 <- ifelse(welfare$religion ==1, "yes", "no")
sr<-table(welfare$sex1, welfare$religion1)
sr
chisq.test(sr)

##### 실습 4 : Cochran-Amitage Trend Test #####
library(moonBook)
View(acs)
#흡연자, 비흡연자, 과거흡연자와 고혈압간의 서로 연관이 있을까?

hs<-table(acs$HBP, acs$smoking)
#smoking의 순서 변경
acs$smoking <- factor(acs$smoking, levels=c("Never","Ex-smoker","Smoker"))
result<-table(acs$HBP, acs$smoking)
result

chisq.test(result)

?prop.trend.test
# X : 사건이 발생한 숫자 
# N : 전체 시도한 횟수 (합계)

# 고혈압이 발생한 사람의 숫자(x에 해당하는 값)
result[2, ]
# smoking 시도 횟수(열 합계 n에 해당)
colSums(result)
prop.trend.test(result[2,], colSums(result))

# 모자이크 그래프로 시각화 
mosaicplot(result)

#색상

mosaicplot(result, color=c("tan1","firebrick2"))
#색상표 참조
colors()
#색상확인
demo("colors")

#행과 열의 위치 변경
mosaicplot(t(result), color=c("tan1","firebrick2"))

#레이블
mosaicplot(t(result), color=c("tan1","firebrick2")
           ,ylab="Hypertension", xlab="Smoking")

#카이제곱테스트는 관계가 있는지 없는지를 보는것이지 
#두 변수만 보고 원인과 결과를 함부로 내서는 안된다 
#최종결과는 선형회귀에서 내야한다. 

mytable(smoking ~ age, data=acs)
# age : 교란변수 
# 교란변수 : 빠지면 해석이 잘못되게 만드는 변수
# 결론 : 원인과 결과에 대해서 섣부른 판단은 금물, 관계가 있는지 없는지만 판단 할 것







