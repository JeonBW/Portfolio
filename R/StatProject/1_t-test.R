# 목적 : 두개의 집단이 같은지 다른지 비교하기 위해서 사용한다. 

# 조건 
# 1) 결과값이 연속변수 (명목변수일 경우 t-test사용 불가능)
#     아닐 경우 : Mann-Whitney U Test, Wilcoxen rank-sum test, Mann-Whitney-wilcoxen test
#                 MWW방식 

# 2) 정규 분포 여부 (정규 분포여야지 t-test 사용가능)
#     아닐 경우 : MWW방식 

# 3) 등분산 : 분산이 비슷해야한다(평균을 기준으로 데이터가 펴져있는 정도가 비슷)
#     아닐 경우 : Welch's t-test

# 4) paired t-test일 경우 Wilcoxen signed rank test (비모수일경우)

# 정규 분포일 경우에는 모수적 통계 방법
# 정규분포가 아닐 경우에는 비모수적 통계방법


# 데이터가 많아질수록 평균에 가까워진다(중심극한정리) = 데이터가 충분하다 = 정규분포
# 데이터가 충분하지 못하다 = 정규분포가 아니다





##### Power Anaysis #####
# 적정한 표본의 갯수를 산출(몇개의 표본을 가지고하면 믿을만 한가)
# cohen's d 
ky <- read.csv("../data/KY.csv", header=T)
View(ky)

table(ky$group)

mean.1 <- mean(ky$score[ky$group==1])
mean.2 <- mean(ky$score[ky$group==2])
mean.1
mean.2
cat(mean.1,mean.2)

#표준편차
sd.1<-sd(ky$score[ky$group==1])
sd.2<-sd(ky$score[ky$group==2])
cat(sd.1,sd.2)


effect_size<- abs(mean.1 - mean.2) / sqrt((sd.1^2 + sd.2^2) / 2)
effect_size

install.packages("pwr")
library(pwr)
?pwr.t.test
pwr.t.test(d=effect_size, type="two.sample", 
           alternative = "two.sided", power = .8, sig.level = .05 )
#적정한 개수는 n개 (적어도 각 그룹의 18명이 있으면 계속 연구해도 된다.)



##### 사례 1 : 두 집단간의 평균 비교#####

install.packages("moonBook")
library(moonBook)
# 2년동안 내원한 사람들
?acs
head(acs)
str(acs)

# 두 집단(남성과 여성)의 나이 차이를 알고 싶다.
# 귀무 가설 : 남성과 여성의 평균 나이에 대해 차이가 없다.
# 대립 가설 : 남성과 여성의 평균 나이에 대해 차이가 있다.

mean.man <- mean(acs$age[acs$sex=="Male"])
mean.woman <- mean(acs$age[acs$sex=="Female"])
cat(mean.man, mean.woman)


##### 정규 분포 테스트 
# (종속변수(결과를 설명해 줄수 있는) ~ 독립변수(종속변수에 영향을 주는))
moonBook::densityplot(age~sex, data=acs)

# 귀무가설 : 정규분포가 맞다.
# 대립가설 : 정규분포가 아니다. 
shapiro.test(acs$age[acs$sex=="Male"])
# 0.05보다 크다 -> 95%안에 들어간다 -> 귀무가설 -> 정규분포가 맞다

shapiro.test(acs$age[acs$sex=="Female"])
# 0.05보다 작다 -> 95%안에 들어가지 않는다. -> 대립가설 -> 정규분포가 아니다.

##### 등분산 테스트 
# 귀무가설 : 등분산이 맞다
# 대립가설 : 등분산이 아니다. 
var.test(age~sex, data=acs)
# p-value가 0.05보다 크므로 등분산이 맞다 
#정규분포가 됐었으면 t-test를 시행했으면 된다.

# MWW검정
wilcox.test(age~sex, data=acs)
# p-value가 0.05보다 많이 작기 때문에 남성과 여성의 평균나이는 차이가 있다.

# 만약에 정규분포였다면? t-test
t.test(age~sex, data=acs, var.test=T, alt="two.sided")

# 등분산이 아니었다면? Welch's t-test
t.test(age~sex, data=acs, var.test=F, alt="two.sided")

##### 사례 2 : 집단이 한개인 경우  #####
#집단이 한개인 경우에는 등분산비교는 할 필요가 없다

# A 회사의 건전지 수명이 1000시간일때 무직위로 뽑아 10개의 건전지 수명에 대해 
# 샘플이 모집단과 다르다고 할 수 있는가?

# 귀무가설 : 모집단의 평균과 같다. 
# 대립가설 : 모집단의 평균과 다르다.


a<- c(980, 1008, 968, 1032, 1012, 1002, 996, 1017, 990, 955)
mean.a<-mean(a)
mean.a
shapiro.test(a)
#p-value가 0.05보다 크므로 정규분포

?t.test
t.test(a, mu=1000, alt="two.sided")
# p-value가 0.05보다 크므로 귀무가설을 채택 / 회사에게 따지면 안된다 

# 어떤 학급의 수학 평균성적이 55점이었다.
# 0교시 수업을 하고 다시 성적을 살펴보았다.
b <- c(58, 49, 39, 99, 32, 88, 62, 30, 55, 65, 44, 55, 57, 53, 88, 42, 39)
mean(b)
shapiro.test(b)
t.test(b, mu=55, alt="greater")
#p-value가 0.05보다 크므로 귀무가설에 포함 / 성적이 오른것이 아니다.


##### 사례 3 : Paired Sample T-Test  p.359#####.
str(sleep)
View(sleep)

before <- subset(sleep, group==1, extra)
before
after <- subset(sleep, group==2, extra)
after

install.packages("PairedData")
library(PairedData)

sleep2 <-paired(before, after)
sleep2
plot(sleep2, type="profile") + theme_bw()

#정규분포 여부
#shapiro.test(sleep$extra[sleep$group==1])
with(sleep, shapiro.test(extra[group==1]))
with(sleep, shapiro.test(extra[group==2]))

# 등분산 확인
with(sleep, var.test(extra[group==1], extra[group==2]))



with(sleep,t.test(extra~ group, data=sleep, paired = T))
# p-value값이 0.05보다 작으므로 대립가설 / 수면제를 먹기 전과 후가 차이가 있다.


##### 실습 1 #####
#dummy : 0은 군을 나타내고, 1은 시를 나타낸다. 
# 시와 군에 따라서 합계 출산율의 차이가 있는지 알아보려고 한다.
# 귀무가설은 차이가 없다 / 대립가설은 차이가 있다.
mydata <- read.csv("../data/independent.csv", header=T)
View(mydata)

mydata.g <- mean(mydata$birth_rate[mydata$dummy==0])
mydata.g
mydata.c <- mean(mydata$birth_rate[mydata$dummy==1])
mydata.c

# 정균분포가 아니면 등분산을 할 필요가 없다.
moonBook::densityplot(birth_rate ~ dummy, data=mydata)
shapiro.test(mydata$birth_rate[mydata$dummy==0])
shapiro.test(mydata$birth_rate[mydata$dummy==1])

wilcox.test(birth_rate ~ dummy, data=mydata)
t.test(birth_rate ~ dummy, data=mydata, var.test=F, alt="two.sided")


##### 실습 2 #####
str(mtcars)
View(mtcars)
# am : 0은 오토  /  1은 수동
# mpg : 연비 
# 오토나 수동에 따라 연비가 같을까? 다를까?


a.mtcars <- mean(mtcars$mpg[mtcars$am==0])
s.mtcars <- mean(mtcars$mpg[mtcars$am==1])

cat(a.mtcars, s.mtcars)

moonBook::densityplot(mpg~am, data=mtcars)
shapiro.test(mtcars$mpg[mtcars$am==0])
shapiro.test(mtcars$mpg[mtcars$am==1])

var.test(mtcars[mtcars$am==1, 1], mtcars[mtcars$am==0,1])
var.test(mpg~am, data=mtcars)

t.test(mpg~am, data=mtcars, var.test=T, alt="two.sided")
t.test(mpg~am, data=mtcars, var.test=T, alt="less")
t.test(mpg~am, data=mtcars, var.test=T, alt="greater")
wilcox.test(mpg~am, data=mtcars)



##### 실습 3 #####
paired <- read.csv("../data/paired.csv", header= T)
View(paired)
data<-read.csv("../data/pairedData.csv",header=T)
View(data)

#쥐의 몸무게가 전과 후의 변화가 있는지 없는지 판단

#데이터를long형으로 변경
library(reshape2)
data1 <- melt(data, id= ("ID"), variable.name = "GROUP", value.name="RESULT")
View(data1)

# 구조를 바꾸는 또다른 방법
install.packages("tidyr")
library(tidyr)
?gather
data2 <- gather(data, key="GROUP", value="RESULT", -ID)
View(data2)


shapiro.test(data1$RESULT[data2$GROUP=="before"])
shapiro.test(data1$RESULT[data2$GROUP=="After"])

with(data1, var.test(RESULT[GROUP=="before"],RESULT[GROUP=="After"]))
t.test(data1$RESULT ~ data1$GROUP, data=data1, paired=T)
#구조를 바꾸지 않고 사용
t.test(data$before, data$After, data=data1, paired=T)


#그래프로 출력
before <- subset(data1, GROUP=="before", RESULT)
before
after <-  subset(data1, GROUP=="After", RESULT)
after
data3<-paired(before,after)
plot(data3, type="profile") + theme_bw()

#또 다른 그래프 출력 
# moonBook::densityplot(RESULT ~ GROUP, data=data1)


##### 또 다른 예제 #####
#시 별로 2010년도와 2015년도의 출산율 차이가 있는가?
data <- read.csv("../data/paired.csv", header= T)
View(data)
data[,"ID"] <-NULL

data1 <- melt(data, id= ("cities"), variable.name = "GROUP", value.name="RESULT")
View(data1)

#data2 <- gather(data, key="GROUP", value="RESULT", -c(ID,cities))

shapiro.test(data1$RESULT[data1$GROUP=="birth_rate_2010"])
shapiro.test(data1$RESULT[data1$GROUP=="birth_rate_2015"])


wilcox.test(RESULT ~ GROUP, data=data1, paired=T)

before <- subset(data1, GROUP=="birth_rate_2010", RESULT)
before
after <-  subset(data1, GROUP=="birth_rate_2015", RESULT)
after
data3<-paired(before,after)
plot(data3, type="profile") + theme_bw()

##### 실습 4 #####
mat <- read.csv("../data/student-mat.csv", header=T)
View(mat)

# 수학점수가 남학생과 여학생에 따라서 같은지 다른지 검증 
# 수학점수는 G1, G2, G3에 걸쳐서 나타나 있다. 


g1_M_mat <- mean(mat$G1[mat$sex=="M"])
g1_F_mat <- mean(mat$G1[mat$sex=="F"])
cat(g1_M_mat,g1_F_mat)

shapiro.test(mat$G1[mat$sex=="M"])
shapiro.test(mat$G1[mat$sex=="F"])

wilcox.test(G1~sex, data=mat) #차이가 없다.

g2_M_mat <- mean(mat$G2[mat$sex=="M"])
g2_F_mat <- mean(mat$G2[mat$sex=="F"])
cat(g2_M_mat,g2_F_mat)

shapiro.test(mat$G2[mat$sex=="M"])
shapiro.test(mat$G2[mat$sex=="F"]) 

wilcox.test(G2~sex, data=mat) # 약간 차이가 있다.


g3_M_mat <- mean(mat$G3[mat$sex=="M"])
g3_F_mat <- mean(mat$G3[mat$sex=="F"])
cat(g3_M_mat,g3_F_mat)

shapiro.test(mat$G3[mat$sex=="M"])
shapiro.test(mat$G3[mat$sex=="F"]) 
wilcox.test(G3~sex, data=mat) # 약간 차이가 있다. 

########################################
summary(mat$G1)
summary(mat$G2)
summary(mat$G3)
table(mat$sex)

#남녀 별로 세번의 시험 평균을 비교해보자 
library(dplyr)
mat %>%  filter(sex=="M") %>% summarise(mean_G1=mean(G1), mean_G2=mean(G2), mean_g3=mean(G3))
mat %>% filter(sex=="F") %>% summarise(mean_G1=mean(G1), mean_G2=mean(G2), mean_g3=mean(G3))
mat %>% select(sex,G1, G2, G3) %>% group_by(sex) %>% summarise(mean_G1=mean(G1), mean_G2=mean(G2), mean_g3=mean(G3),
                                                               cnt_g1=n(),cnt_g2=n(),cnt_g3=n(),
                                                               sd_g1=sd(G1),sd_g2=sd(G2),sd_g3=(sd(G3)))
mean_G1/cnt_g1


shapiro.test(mat$G1[mat$sex=="M"])
shapiro.test(mat$G1[mat$sex=="F"])
shapiro.test(mat$G2[mat$sex=="M"])
shapiro.test(mat$G2[mat$sex=="F"])
shapiro.test(mat$G3[mat$sex=="M"])
shapiro.test(mat$G3[mat$sex=="F"])

var.test(G1 ~ sex, data=mat)
var.test(G2 ~ sex, data=mat)
var.test(G3 ~ sex, data=mat)

t.test(G1 ~ sex, data=mat, var.equal = T, alt="two.sided")
t.test(G2 ~ sex, data=mat, var.equal = T, alt="two.sided")
t.test(G3 ~ sex, data=mat, var.equal = T, alt="two.sided")

# 남학생이 여학생보다 더 잘하단고 보기는 힘들다 

t.test(G1 ~ sex, data=mat, var.equal = T, alt="less")
t.test(G2 ~ sex, data=mat, var.equal = T, alt="less")
t.test(G3 ~ sex, data=mat, var.equal = T, alt="less")

wilcox.test(G1~ sex, data=mat)
wilcox.test(G2~ sex, data=mat)
wilcox.test(G3~ sex, data=mat)




# 같은 학생 입장에서 G1과 G3에 대해서 변화가 있었는지 -> 시간

# 첫번째 시험과 마지막 시험의 평균 비교

mat%>%select(G1,G3) %>% summarise(mean_g1=mean(G1),mean_3=mean(G3))
#long 타입으로 변경
library(tidyr)
mydata <- gather(mat, key="GROUP", value="RESULT", "G1", "G3")
head(mydata)
tail(mydata)

t.test(mydata$RESULT ~ mydata$GROUP, data=mydata, paired=T)
wilcox.test(mydata$RESULT ~ mydata$GROUP, data=mydata, paired=T)

?t.test
t.test(mat$G1, mat$G3, paired=T)









