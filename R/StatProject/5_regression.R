##### 단순 회귀 분석 #####
# y = ax + b  (a=기울기, 회귀 계수 / x = 독립변수 / b = 절편 / y = 종속변수  )
# a를 구하기 위한 공식 : 최소제곱법(Least Square)
# 미국 여성의 키와 몸무게 (30~39세 추정) : 인치 / 파운드
str(women)
# 키가 크면 몸무게도 많이 나갈까?  독립변수 - 키 / 종속변수 - 몸무게
# 몸무게가 많이 나가기 때문에 키가 크다? 독립변수 - 몸무게 / 종속 변수 - 키 (;)

# 키가 크면 몸무게도 많이 나갈까 
View(women)

plot(weight ~ height, data=women)
#양의 관계 

fit <- lm(weight ~ height, data=women)
fit
#Intercept : 절편 / heitht : 기울기  / y=3.45x
abline(fit, col="blue")
summary(fit)
# 설명계수(R-squared) : 상관계수(-1~1) 제곱 
# 얼만큼 잘 설명하고 있는지 
# 수정된 R 계수 

# 잔차의 총합이 0이 되기때문에 제곱을 사용


plot(fit)
# residuals 잔차도 
#오차가 어떤 패턴을 이루고 있어서는 안된다. 랜덤한 오차가 발생해야한다.
# fit는 약간의 패턴을 가지고 있으므로 만족스럽지 못하다 
# 선형성 확인 

# QQ도 정규분포를 확인할때 쓰는 그래프
# 직선에 잘 모여있으면 정규분포 / fit은 잘 모여있지 않으므로 정규분포가 아니다.

# scale-Location 등분산성
# Y축은 표준편차 : 데이터가 무의미하게 퍼져 있어야 한다. 
# fit은 어느정도 퍼져 있다. 

# Cook's D : 이상치를 확인할 때 사용 

par(mfrow = c(2,2))
plot(fit)

#선형성을 만족하지 못할때 만족시키게 하기 위해서 사용하는 방법 : 다항회귀분석
#다항 회귀 분석 (polynomial regression)
# y=ax+b -> y=x^
fit2<- lm(weight ~ height + I(height^2), data=women)
summary(fit2)
par(mfrow = c(1,1))
plot(weight ~ height, data=women)
lines(women$height, fitted(fit2), col="red")

par(mfrow = c(2,2))
plot(fit2)

### 실습 1 ###
mydata<-read.csv("../data/regression.csv", header=T)
View(mydata)

#social_welfare : 사회 복지 시설 
#active_firms : 사업체 수
#urban_park : 도시 공원
#doctor : 의사
#tris : 폐수 배출 업소
#kindergarten : 유치원 

# 종속 변수 : birth_rate
# 독립 변수 : kindergarten
# 가설 : 유치원 수가 많은 지역에 합계 출산율도 높은가 ?
#        또는 합계 출산율이 유치원 수에 영향을 받는가 ? 
plot(birth_rate ~ kindergarten, data=mydata)

mydata2 <- lm(birth_rate ~ kindergarten, data=mydata)
summary(mydata2)
abline(mydata2, col="blue")

# 설명력이 너무 떨어진다. - 변수를 가지고 원인결과를 설명할 수 있는지 회의적
# 설명력을 높이기위해서 다양한 교정방법을 동원
# 설명력을 높이는 것은 매우 중요
# 설명력에 너무 치중하다 보면 다른 곳을 놓칠 수 있음

par(mfrow = c(2,2))
plot(mydata2)
# 선형성 : 거의 패턴이 없이 무작위 하게 흩어져 있다.
# 정규분포 : 상당히 떨어져 있는 부분이 있어 정규분포가 살짝 불안하다.
# 등분산성 : 자유롭게 흩어져 있어 등분산성도 만족
# Cook's D 는 다중회귀에서만 볼 것 (단순회귀에서는 pass)

# 정규분포를 교정 
# 독립변수나 종속변수에다가 제곱을 해주거나 0.5를 곱해주거나(루트) -> 어떤 값을 곱해주는 것이 좋은지 찾아야한다.

# 로그를 통해서
mydata3 <- lm(log(birth_rate) ~ log(kindergarten), data=mydata)
summary(mydata3)

par(mfrow = c(2,2))
plot(mydata3)
shapiro.test(resid(mydata2))
shapiro.test(resid(mydata3))

# 유치원이 많다고 출산율이 높지는 않다.

######
# 독립변수를 dummy로 변경(군:0, 시:1)
plot(birth_rate ~ dummy, data=mydata)

mydata4 <- lm(birth_rate ~ dummy, data=mydata)
summary(mydata2)
# dummy라는 기울기 값이 음수 
# 군을 기준으로 했을 때 시가 음수 -> 군보다 시가 출생률이 낮다



### 실습 2 ###
# www.kaggle.com:House Sales Price in Kings county
house <- read.csv("../data/kc_house_data.csv",header=T)
View(house)
str(house)

# 종속변수 : price
# 독립변수 : sqft_living (거실 크기)
# 거실크기가 커지면 집값도 높아지는가? 

reg1 <- lm(price ~ sqft_living, data=house)
summary(reg1)
# 회귀 계수 280.624
# std.error 표준 오차 / Estimate : 회귀계수, 비표준 계수 
# 거실 크기가 1피트 증가할때마다 매매가격이 280달러 증가한다
# 표준오차 : 서로 다른 데이터를 가지고 똑같이 회귀분석했다고 가정했을 때 
# 설명 계수를 높이기 위해 가장 많이 쓰는 방법은 독립변수를 추가하는 것 
# -> 자우도가 계속증가 -> 비용이 발생 -> 과적합 -> 이를 해결하기 위해 Adjusted R-squared

plot(house$sqft_living, house$price)
# 패턴이 있어 R제곱이 높아도 의미가 없음.(패턴이 없어야 한다.)
# 설명력을 무조건 높이는 것이 무조건 좋은것은 아니다 .

#잔차도
par(mfrow=c(2,2))
plot(reg1)

plot(house$sqft_living, house$price)

### 표준화 계수
# 표준 오차 : 데이터가 평균에 모여 있는지 퍼져있는지 
# 전문통계프로그램에서는 출력 (R에서는 X)
# Estimate와 비교되는 계수 (Std.error X)
# 표준화 계수는 단위를 표준화 시켜주는 것 

##### 다중 회귀 #####
# 종속 변수 : price
# 독립 변수 : sqft_living, floors, waterfront
# 어떤 것이 집값의 더 영향을 미치는가

reg1<- lm(price ~ sqft_living + floors + waterfront, data=house)
summary(reg1)

# 변수를 추가하니 설명력이 높아짐 
# 각각 양의 방향으로 집값의 의미가 있음
# Estimate로는 누가 더 집값의 영향을 주는 지 알 수 없음.

#표준화계수 확인
install.packages("lm.beta")
library(lm.beta)

reg2<- lm.beta(reg1)
summary(reg2)
# Standardized
# 거실의 크기가 가장 영향력이 크다, 단 믿을만한 것인지 다시한번 테스트 해야한다.
# 안쓰는 이유 -> 어렵고 복잡해서 
# 절대적으로 맹신해서는 안되고 참고하기 위해서 사용하는 정도로 


### 더미 변수 (머신러닝할때 필수)
# 숫자는 숫자지만 숫자로서의 의미나 순서가 없어야 한다.
# 0또는 1로 만든다. 
# 모든 값이 0이면 기본값 / 나머지는 비교할 수 있는 값

# 값이 오직 "0"과 "1"로만 이루어짐
# 이산형/범주형 변수를 연속형 변수처럼 사용하기 위해서
# 필요한 더미변수의 갯수는 범주의 갯수 -1 개 


### 다중 공선성
# 원인 : 독립변수들끼리 너무 많이 겹쳐서 발생하는 문제를 의미한다.
# 확인방법
#   1) 산포도, 상관계수 : 상관계수가 0.9(90%)를 넘게되면 다중공선성 문제
#   2) VIF(variance Inflation Factor) : 분산 팽창 지수
#       - 일반적으로 10보다 크면 문제가 있다고 판단(연속형 변수) 
#       - 더미 변수일 경우에는 3 이상이면 문제가 있다고 본다. 
#       - sqrt(vif) > 2 다중공선성을 의심 
# 해결방법
#   1) 변수를 뺀다. (굉장히 위험하다. 만약 굉장히 중요하고 영향력이 있는 변수라면 제대로 분석이 불가능하다.)
#   2) 주성분 분석 (비슷한 변수들을 하나로 묶어서 줄이는 방법)
# 최소제곱법이 힘들어진다 -> 정확한 선을 찾기 힘들어진다. -> 잘못된 해석을 하게 된다(의미가 있는데 없다고 나오거나 그 반대)
# 지나치게 설명이 과하게 되는 
# 어느정도 허용된 범위내에서는 괜찮지만 지나치면 안된다. 


### 실습 3 ###
house <- read.csv("../data/kc_house_data.csv",header=T)
View(house)

# 독립변수 : sqft_living, bathrooms, sqft_lot, floors
# 종속변수 : price 
# 독립변수들간의 상관관계 확인(다중 공선성 확인)
x= with(house, cbind(sqft_living, bathrooms, sqft_lot, floors))
cor(x)

cor(x, house$price)

reg1 <- lm(price ~ sqft_living, data=house)
summary(reg1)

reg2 <- lm(price ~ sqft_living + floors, data=house)
summary(reg2)
# 의미가 있는지 없는지 헷갈릴때 -> 조절변수를 사용
# 조절변수 (interactive term, 상호변수, 교호변수)
reg2_1 <- lm(price ~ sqft_living + floors + sqft_living*floors, data=house)
summary(reg2_1)

#floors가 음수값이 나와 다중공선성 확인
install.packages("car")
library(car)
vif(reg2_1)

# sqft_living:floorsrk 21이므로 10보다 훨씬크다 -> 다중공선성 
# 단순히 P-value 값만 봐서는 안된다. sqft_living:floors 를 빼야한다. 
# 거실의 크기를 빼고 floors와 다른 변수들 비교

x <- with(house,cbind(floors, sqft_above, sqft_basement))
cor(x)
cor(x, house$price)

reg3 <- lm(price ~ floors + sqft_above + sqft_basement, data=house)
summary(reg3)

vif(reg3)

### 실습 4 ###
View(state.x77)

# 종속변수 : Murder
# 독립변수 : Population, Illiteracy, Income, Frost
states <- as.data.frame(state.x77[, c("Murder", "Population","Illiteracy",
                                      "Income", "Frost")])
View(states)
fit <- lm(Murder ~ Population + Illiteracy + Income + Frost, data=states)
summary(fit)
# 수입하고 결빙일은 살인율과 관계가 없는 것으로 나옴 -> 수입하고 결빙을은 해석할 필요가 없다.
# 가장 좋은 변수들을 찾아서 그것들을 모아 분석하는것이 가장 바람직하다.

sqrt(vif(fit))
# 다중공선성 문제는 발생하지 않았다.

# 이상 관측치 
#     1) 이상치(outline) : 표준잔차 2배 이상 크거나 작은 값(의심해 볼 수 있다. 무조건X)
#     2) 큰 지레점(High leverage points) : p(절편을 포함한 인수들의 숫자) / 데이터의 갯수n 의 값이 
#                                          2~3배 이상되는 관측치 
#                                         (5/50 = 0.1 보다 2~3배 더 크다면 의심)
#     3) 영향 관측치(Influential Observation, Cook's D) : 일반적인 사회과학에서 주어지는 데이터들에는맞지 않다.
#                                     독립변수의 수 / (샘플 수 - 예측 인자의 수 - 1)
#                                           4/(50-4-1) = 0.1 이 값보다 클 경우 이상치일 가능성이 크다.


influencePlot(fit, id=list(method="identify"))
# 표준잔차 : Y축을 기준으로 -2 ~ 2 이상 넘어가는 데이터들 
# 큰지레점 : X축을 기준으로 0.2~0.3 이상 되는 데이터들
# 영향관측 : 원의 크기 / 원이 클수록 의심 
# Hat 큰 지레점


## 회귀 모형의 교정 
# 정규분포가 아닐경우(정규성을 만족하지 않을 때)
par(mfrow=c(2,2))
plot(fit)


powerTransform(states$Murder)
#murder라는 종속변수에다가 0.605542 배를 계산해봐라
#값을 그대로 쓰기 보다는 -2, -1, -0.5, 0, 0.5, 1, 2 로 묶어서 계산하는게 일반적이다.
summary(powerTransform(states$Murder))

# 선형성을 만족하지 않을 때
boxTidwell(Murder ~ Population + Illiteracy, data=states)
# populateion에 0.86배를 해보고 illiteracy에 1.3배 해봐라 / p-value 값을 0.05 보다 크므로 의미가 없다.

#등분산성을 만족하지 않는 경우
ncvTest(fit)
# p-value가 0.18이기 때문에 의미는 없음
# 만약 만족하지 않을 경우
spreadLevelPlot(fit)

### 회귀모형 선택 : 
# Backward Stepwise Regression

#모든 변수를 다 던져주고 하나씩 빼면서 검사 
#AIC(Akaike's Information Criterion) 관계가 있는지 없는지 판단해서 뽑아내는 값
#AIC가 작으면 작을수록 좋은 모델 
#하나씩 빼면서 값이 커질때 까지 

# Forward Stepwise Regression 
#하나씩 추가하면서 더 이상 안좋아 질때까지

fit1<- lm(Murder ~ ., data=states)
summary(fit1)
fit2 <- lm(Murder ~ Population + Illiteracy, data=states)
summary(fit2)

AIC(fit1, fit2)
# fit2가 더 나은 모델이다 

#backward
full.model <- lm(Murder~., data=states)
redeuced.model <- step(full.model, direction= "backward", trace=0)
redeuced.model

#forward 
min.model <- lm(Murder~1, data=states)
fwd.model <- step(min.model, direction = "forward", 
                  scope=(Murder ~ Population + Illiteracy + Income + Frost ))

# 언제나 무조건 따르는 것은 좋지 않다. 


# all subset regression (모든 변수를 조합)
install.packages("leaps")
library(leaps)

leaps <- regsubsets(Murder ~ Population + Illiteracy + Income + Frost, 
                    data=states, nbest=4)
plot(leaps, scale="adjr2")
# 역시 무조건 믿으면 안된다 

# 중요한 것은 회귀분석은 예측이다



##### 실습 4 #####
mydata<-read.csv("../data/regression.csv", header=T)
View(mydata)

#social_welfare : 사회 복지 시설 
#active_firms : 사업체 수
#urban_park : 도시 공원
#doctors : 의사
#tris : 폐수 배출 업소
#kindergarten : 유치원 
str(mydata)
reg1<- lm(birth_rate ~ cultural_center + social_welfare + active_firms + 
            urban_park + doctors+ tris + kindergarten + dummy, data=mydata)
summary(reg1)
# cultural_center와 urban_park는 가장 의미 없기 때문에 제외하고 다시한번 선형분석 

# 변수 조정
reg2<- lm(birth_rate ~ social_welfare + active_firms + 
            doctors+ tris + kindergarten + dummy, data=mydata)
summary(reg2)
# backward
full.model <-lm(birth_rate~., data=mydata)
reduced.model <- step(full.model, direction = "backward")
# backward를 돌리기에는 적합한 모델이 아님

#forward 
full.model <- lm(birth_rate~1, data=mydata)
fwd.model <- step(full.model, direction = "forward", 
                  scope=(birth_rate~cultural_center + social_welfare 
                         + active_firms + urban_park + doctors+ tris + 
                           kindergarten + dummy))
#forward도 결과가 신뢰가 가지 않음(urban_park, cultural_center가 의미없다고 나오기는 한다.)

#plot으로 확인

plot(reg2)
# 선형성 : 0을 기준으로 무의미하게 흩어져 있음
# 정규성 : 정규성이 약간 의심되긴함(끝부분)
# 등분산성 : 패턴없이 퍼져있어 괜찮음
# 이상치 : 없는것으로 판단
# 정규성이 걱정됨
# 정규성 확인(검정)
shapiro.test(resid(reg2))
# 람다승
summary(powerTransform(mydata$active_firms))
#0.5승
reg3<- lm(log(birth_rate) ~ log(social_welfare) + log(active_firms) + 
          log(doctors) + log(tris) + log(kindergarten) + dummy, 
          data=mydata)
summary(reg3)
shapiro.test(resid(reg3))

# 다중공선성 
sqrt(vif(reg1))
sqrt(vif(reg2))
sqrt(vif(reg3))
# 변수들간의 상관관계는 높지는 않다.
plot(reg3)

#등분산성
ncvTest(reg1)
ncvTest(reg2)
ncvTest(reg3)
spreadLevelPlot(reg3)


##### 로지스틱 회귀 분석 (이항변수/참 아니면 거짓) #####
# 로짓(logit) = log(오즈비)
# 로짓 : 이항변수를 연속변수처럼 쓸 수 있게 만드는 계산 공식
# 로지스틱 : 곡선의 방정식 
#            최대값 1과 최소값0사이에서 구분 지어 놓음 
# y=e^(ax+b) / y값을 로그로 취했기 때문에 ax+b가 지수로 넘어감
# x가 1증가할때 바다 e^b만큼 증가 
# 일반화 선형 모델 : glm()
# 일반 선형 모델에서는 직선이라 이상치가 들어왔을때 값이 바뀌어 버릴 수 있음.

# titanic 
titanic <- read.csv("../data/train.csv",header=T)
View(titanic)
 
# 종속변수 : Survived(1:생존, 0:비생존)
# 독립변수 : Pclass(1st, 2nd, 3rd) -> 더미 변수로 만들어야 한다.

#더미변수
titanic$Pclass1 <- ifelse(titanic$Pclass == 1, 1, 0)
titanic$Pclass2 <- ifelse(titanic$Pclass == 2, 1, 0)
titanic$Pclass3 <- ifelse(titanic$Pclass == 3, 1, 0)

View(titanic)

#선형회귀분석
# 1등급이 기준이되면 제외하고 넣을 것
reg1 <- lm(Survived ~ Pclass2 + Pclass3, data=titanic)

summary(reg1)
# 1등급은 0.62963 / 2등급은 (0.62963-0.15680)0.4728 47% / 3등급은 (0.62963-0.38727)24%
# 죽었는지 살았는지 보는사람마다 해석이 다달라지기 때문에 해석이 불가능하다.
# 선형회귀분석으로는 결과값을 내리기 힘들다. (온갖 추축이 다 난무)

# 로지스틱 회귀분석
reg2<-glm(Survived ~ Pclass2 + Pclass3, data=titanic, family = binomial)
summary(reg2)
# Estimate가 양수면 생존가능성이 높은것 / 음수면 생존가능성이 낮은 것

(exp(0.5306)-1)*100
# 1등급일 경우 생존 가능성이 가장 높다.

(exp(-0.6394)-1)*100
# 2등급일 경우에는 1등급보다 생존가능성이 낮다

(exp(-1.6704)-1)*100
# 3등급일 경우 생존가능성이 가장 낮다.

# 독립변수 : Age, Fare, Gender, SibSp(동반자)
unique(titanic$SibSp)
table(titanic$SibSp)

titanic$SibSp0 <- ifelse(titanic$SibSp == 0, 1, 0) 
titanic$SibSp1 <- ifelse(titanic$SibSp == 1, 1, 0) 
titanic$SibSp2 <- ifelse(titanic$SibSp == 2, 1, 0) 
titanic$SibSp3 <- ifelse(titanic$SibSp == 3, 1, 0) 
titanic$SibSp4 <- ifelse(titanic$SibSp == 4, 1, 0) 
titanic$SibSp5 <- ifelse(titanic$SibSp == 5, 1, 0) 

titanic$GenderFeMale <- ifelse(titanic$Sex == "female", 1, 0) 
titanic$GenderMale <- ifelse(titanic$Sex == "male", 1, 0)

# 이항의 결정을 뚜렷하게 나타낼 수 있다. 
# 선형회귀도 가능하긴하나 정확도면에서 로지스틱이 훨씬 좋다 .
reg3 <- glm(Survived ~ Age + Fare + GenderMale + SibSp1 + SibSp2 + 
              SibSp3 + SibSp4 + SibSp5, data= titanic, family=binomial)
summary(reg3)

# Age 
exp(-0.0224) # 나이가 1살 많을수록 생존가능성은 0.98배 증가 (1배가 안되면 감소)

# Fare 해석 
exp(0.014946) # 요금이 1$ 증가할수록 생존가능성은 1.015배 증가

# SibSp3 해석 
exp(-2.461568) # 동승자가 없는 사람보다 동승자가 3명인 사람들의 생존가능성은 0.085배 증가 
(exp(-2.4615)-1)*100 # 생존가능성이 91.5%감소

#Gendermale 해석
exp(-2.411534) # 여성보다 남성의 생존가능성은 0.089배 높다. / 남성의 생존가능성은 91.03% 낮다
(exp(-2.411534)-1)*100
# 음수일 때는 백분율로 계산해서 감소로 표현하는 것이 좋다 


(1/exp(-2.4115)-1)*100 #남성에 비해 여성의 생존률은 1015% 높다.

##### survival 패키지를 이용한 colon #####
library(survival)
View(colon)
?colon
# 종속변수 : status (1: 사망하거나 재발한 경우 / 0 : 재발없이 잘 생존)

# 결측치 확인
table(is.na(colon))
colon1 <- na.omit(colon)
table(is.na(colon1))

result <- glm(status ~ rx + sex + age + obstruct + perfor + adhere + 
                nodes + differ + extent + surg, family = binomial, data=colon1)
summary(result)

#정말 영향력있고 중요한 변수만 골라서 확인하고 싶을때
#backward
reduce.model=step(result)
status ~ rx + obstruct + adhere + nodes + extent + surg

summary(reduce.model)
library(moonBook)
extractOR(reduce.model)

# 과산포 
# 과산포는 종속변수의 실제분산이 이항분포에서 기대되는 에측분석보다 클 때 생길 수 있으며
# 과산포는 검정의 표준오차를 뒤틀리게 만들어 검정을 부정확하게 늘릴 수 있다
# 분산(산포도)이 너무 넓게 퍼지거나 너무 좁게 퍼져서 나중에 값을 제대로 예측하지 못할 때 
# 부정확하게 만들 수 있다.

# 과산포가 없을때 : binomial
# 과산포가 있을때 : quasibinomial

# 과산포 유무 확인 : pchisq()
fit <- glm(status ~ rx + obstruct + adhere + 
             nodes + extent + surg, family = binomial, data=colon1)

fit.od <- glm(status ~ rx + obstruct + adhere + 
             nodes + extent + surg, family = quasibinomial, data=colon1)
summary(fit.od)

# quasibinomial의 분산값* binomial의 잔차 
pchisq(summary(fit.od)$dispersion * fit$df.residual, fit$df.residual,lower=F)
# 나온 결과값이 0.05보다 크다면 과산포가 없다고 볼 수 있다. 

# 오즈비를 그려주는 함수 
#(p-value를 나타냄 / 가운데 점선 1/ 점에서 벗어나 일수록 의미가 있는 것 )
ORplot(fit)
ORplot(fit, main="Plot for Doos Ratio", type=2,show.OR=F,show.CI = T, pch=15, lwd=5)
