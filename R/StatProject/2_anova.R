# 조건 
# 1) 결과값이 연속변수 
#   - 아닐 경우 : Kruskal-wallis H test 
# 2) 정규 분포 여부
#   - 아닐 경우 : Kruskal-wallis H test
# 3) 등분산 여부
#   - 아닐 경우 : welch's anova
# 모든 조건을 만족하는 경우 anova를 사용하고 사후검정으로는 tukey 사용


##### 사례 1 : One Way Anova #####

library(moonBook)
View(acs)

# LDLC : 저밀도 콜레스테롤 수치 : 종속 변수 
# Dx(진단 결과) : STEMi(심근경색), NSTEMi(), unstable angina : 독립변수

moonBook::densityplot(LDLC ~ Dx, data = acs)

# 정규분포 검정
with(acs, shapiro.test(LDLC[Dx=="NSTEMI"]))
with(acs, shapiro.test(LDLC[Dx=="STEMI"]))
with(acs, shapiro.test(LDLC[Dx=="Unstable Angina"]))

out = aov(LDLC ~ Dx, data =acs)
out
shapiro.test(resid(out))

# 등분산 검정
bartlett.test(LDLC ~ Dx, data=acs )

# 정규분포이고 등분산일 경우
out = aov(LDLC~ Dx, data=acs)
summary(out)  #Pr(>F) 가 p-value / 0.05보다 작으므로 차이가 있다.
# 뒤에 ** 은 강도 

# 연속변수가 아니거나 정규분포가 아닌 경우
kruskal.test(LDLC ~ Dx, data = acs)

# 등분산이 아닐 경우
oneway.test(LDLC ~ Dx, data = acs, var.equal = F) #var.equal 디폴트값은 False
?oneway.test

## 사후 검정
#aov()를 사용 했을 경우 : TukeyHSD()
TukeyHSD(out)
# STEMi-NSTEMi와 Unstable Angina-STEMi는 차이가 없다
# Unstable Angina-NSTEMI 는 차이가 있다.

# kruska.test()를 사용했을 경우
install.packages("pgirmess")
library(pgirmess)

kruskalmc(acs$LDLC, acs$Dx)

#사후검증이 얼마나 어려운가?
str(InsectSprays)
View(InsectSprays)

moonBook::densityplot(count~spray, data=InsectSprays)
kruskalmc(InsectSprays$count, InsectSprays$spray)

install.packages("userfriendlyscience")
library(userfriendlyscience)

posthocTGH(x=InsectSprays$spray, y=InsectSprays$count, method = "games-howell")

posthocTGH(x=acs$Dx, y=acs$LDLC, method="games-howell")

# 결론 웬만하면 kruskalmc를 쓰고 안되면 posthocTGH를 사용

#oneway.test()를 사용했을 경우의 사후 검정 (등분산이 아닐 경우)
install.packages("nparcomp")
library(nparcomp)
result <- mctp(LDLC ~ Dx, data=acs)
summary(result)

##### 실습 예제 #####

head(iris)
table(iris$Species)

# 품종별로 Sepal.width의 평균 차이가 있는가? 만약 있다면 어느 품종과 차이가 있는가 
with(iris, shapiro.test(Sepal.Width[Species=="setosa"]))
with(iris, shapiro.test(Sepal.Width[Species=="versicolor"]))
with(iris, shapiro.test(Sepal.Width[Species=="virginica"]))

# 평균에서 떨어져 있는 거리 : 잔차 
out <- aov(Sepal.Width ~ Species, data = iris)
# 정규분포 여부
shapiro.test(resid(out))
# 등분산
bartlett.test(Sepal.Width ~ Species, data=iris )

#품종별로 차이가 있다 Pr(>F)가 0.05보다 작다
out = aov(Sepal.Width ~ Species, data=iris)
summary(out)

#사후검정
TukeyHSD(out)
# 3개다 차이가 있다.
kruskalmc(iris$Sepal.Width, iris$Species)

##### 실습 2 #####

data<-read.csv("../data/anova_one_way.csv", header=T)
View(data)
# 시군구 에 따른 합계 출산률의 차이가 있는가? 있다면 어느것과 차이가 있는가?
out <- aov(birth_rate ~ ad_layer, data=data)
shapiro.test(resid(out))


kruskal.test(birth_rate ~ ad_layer, data = data)

kruskalmc(data$birth_rate, data$ad_layer)
posthocTGH(x=data$ad_layer, y=data$birth_rate, method = "games-howell")
#구와군 구와시는 차이가 있다.

moonBook::densityplot(birth_rate~ad_layer, data=data)

#중심극한정리에 따라 정규분포로 처리해도 상관없다.
out = aov(birth_rate ~ ad_layer, data = data)
summary(out)
TukeyHSD(out)

##### 실습 3 #####
# 실습 데이터 : http://www.kaggle.com
telco <- read.csv("../data/Telco-Customer-Churn.csv", header=T)
View(telco)
# R에서는 5천개까지만 정규분포를 확인할 수 있다. 
str(telco)

# 독립변수 : PaymentMethod(Bank transfer, Credit card, Electronic check, Mailed check)
# 종속변수 : Total Charges
unique(telco$PaymentMethod)

# 각 지불방식별로 갯수(인원수)와 평균 금액을 조회
telco %>% select(PaymentMethod, TotalCharges) %>% group_by(PaymentMethod) %>%
  summarise(n=n(), mean=mean(TotalCharges, na.rm=T))

moonBook::densityplot(TotalCharges ~ PaymentMethod, data=telco)

#정규분포 여부 
with(telco, shapiro.test(TotalCharges[PaymentMethod == "Bank transfer (automatic)"]))
with(telco, shapiro.test(TotalCharges[PaymentMethod == "Credit card (automatic)"]))
with(telco, shapiro.test(TotalCharges[PaymentMethod == "Electronic check"]))
with(telco, shapiro.test(TotalCharges[PaymentMethod == "Mailed check"]))

out <- aov(TotalCharges~PaymentMethod, data=telco)
shapiro.test(resid(out))

x = telco$TotalCharges[telco$PaymentMethod == "Bank transfer (automatic)"]
x
# 데이터를 적게 만들면 정규분포를 통과할 가능성이 높아진다. 
x1 <- sample(x, 30, replace=F)
shapiro.test(x1)
x2 <- sample(x, 100, replace=F)
shapiro.test(x2)
x3 <- sample(x, 10, replace=F)
shapiro.test(x3)

#앤더슨 달링 테스트 : 데이터가 5천개가 넘어갈때 정규분포를 확인하고 싶을때 
install.packages("nortest")
library(nortest)
#길이가 똑같아야 한다. 
nortest::ad.test(out)

#등분산 테스트
bartlett.test(TotalCharges ~ PaymentMethod, data=telco)

# welches's anova
oneway.test(TotalCharges ~ PaymentMethod, data=telco, var.equal = F)

#사후검증
library(nparcomp)
result <- mctp(TotalCharges ~ PaymentMethod, data=telco)
summary(result)

plot(result)
#만약 정규분포가 아니라는 상황에서 테스트를 한다면
kruskal.test(TotalCharges ~ PaymentMethod, data=telco)
kruskalmc(telco$TotalCharges, telco$PaymentMethod)

#상자 그림 그래프 (x는 독립 y는 종속)
library(ggplot2)
ggplot(telco, aes(telco$PaymentMethod, telco$TotalCharges)) + geom_boxplot()

############################################
##### 사례 2 : Two Way ANOVA #####
mydata<- read.csv("../data/anova_two_way.csv", header=T)
View(mydata)
#multichild : 다가구 자녀 지원조례
# ad_layer:multichild 상호변수 
# ad_layer:multichild 독립변수만 가지고 검증하는 것이 아니라 하나씩하나씩 크로스 
# ad_layer가 multichild에게 어떤 영향을 미치는지 
out<-aov(birth_rate ~ ad_layer + multichild + ad_layer:multichild, data=mydata)

shapiro.test(resid(out))

summary(out)

result=TukeyHSD(out)

plot(result)

result

#군에서 지원하는 것에는 차이가 있고 구와 시에서 지원하는 것은 차이가없다.
#군에서 지원하는 것이 효과(차이)가 있다


ggplot(mydata, aes(birth_rate, ad_layer, col=multichild)) +
  geom_boxplot()


#상호변수를 제거
out<-aov(birth_rate ~ ad_layer + multichild, data=mydata)
shapiro.test(resid(out))
summary(out)

TukeyHSD(out)

##### 실습 1 #####

telco <- read.csv("../data/Telco-Customer-Churn.csv", header=T)
View(telco)
str(telco)

# 독립변수 : PaymentMethod(Bank transfer, Credit card, Electronic check, Mailed check)
# 독립변수 : contract
# 종속변수 : Total Charges
out<-aov(TotalCharges ~ PaymentMethod + Contract + PaymentMethod:Contract, data=telco)
summary(out)

TukeyHSD(out)

ggplot(telco, aes(TotalCharges, PaymentMethod, col=Contract)) + geom_boxplot()
ggplot(telco, aes(TotalCharges, Contract, col=PaymentMethod)) + geom_boxplot()
ggplot(telco, aes(PaymentMethod, TotalCharges, col=Contract)) + geom_boxplot()

 
#결론 : mailed check는 어떤 계약을 사용해도 큰 차이가 나지 않는다 
#Electronic check 결제방식은 다른 결제방식에 비해 계약기간에 따른 차이가 가장 크다.
#Month-tomonth 계약은 어떤 결제방식을 써도 큰 차이가 없다.
#Two year 계약은 다른 계약에 비해 결제방식에 따른 차이가 크다.


##### 사례 3 : RM ANOVA#####

#구형성(Sphericity) : 이미 독립성이 깨졌으므로 최대한 독립성과 무작위성을 
#                     확보하기 위한 조건 
# 1) 가정 : 반복 측정된 자료들의 시차에 따른 분산이 동일 
# 2) Mouchly의 단위 행렬 검정 : p-value가 0.05보다 커야 함.
#  (그래야 구형성을 보장받을 수 있다 - 동일성을 보장 받음)
# 3) Greenhouse-Geisser와 Huynh-Feidt 값(GGeps)이 1에 가까울수록 구형성이 타당 

# 종속변수가 3개(pre, 3month, 6month) 
df = data.frame()
df=edit(df)
df

means<-c(mean(df$pre), mean(df$after3m), mean(df$after6m))
means

install.packages("gplots")
library(gplots)
plotCI(x=means, type="l", ylab="score", xlab="month", main="RM")

#둘의 차이는 선형모델 (차이가 있냐/없냐를 선으로 따지는것)
#RM anova를 쓰기 위한 준비
multimodel <- lm(cbind(df$pre, df$after3m, df$after6m) ~ 1)
trials <- factor(c("pre","after3m","after6m"), ordered=F)
install.packages("car")
library(car)

model1 <- Anova(multimodel, idata=data.frame(trials), idesign = ~ trials, type="III")

#III 제곱합(SS) : 분산계산할때 사용 (분산식에서 분자) 일반적으로 3번째 타입 사용
?Anova
summary(model1, multvariate=F)
#차이가 있다. Mauchly로 구형성 확인 0.05보다크다 (작으면 gre...으로 확인)

### 사후 검정 
#기존에 쓰던 anova함수로
df2 <- df

library(reshape2)
library(tidyr)
df2 <- melt(df2, id.vars="id")
df2
colnames(df2) <- c("id", "time","value")
df2

#그래프로 나타내기 위해 id와 time을 factor로
df2$id <- factor(df2$id)
df2$time <- factor(df2$time)
str(df2)

ggplot(df2, aes(time, value)) + geom_line(aes(group=id, col=id)) + geom_point(aes(col=id)) 

library(dplyr)
df2.mean <- df2 %>% group_by(time) %>% summarise(mean=mean(value),sd=sd(value))

ggplot(df2.mean, aes(time, mean)) + geom_point() + geom_line(group=1)

out <- aov(value ~ time + Error(id/time), data=df2)
summary(out)

#사후 검정
with(df2, pairwise.t.test(value, time, paired = T, 
                          p.adjust.method = "bonferroni"))
#1=pre / 2= after3m / 3= after6m
#투약전과 3개월후는 차이가 없다. 
#투약전과 6개월후는 차이가 있다.
#3개월후와 6개월 후는 차이가 있다.

##### 실습 1 #####
#7명의 학생이 총 4번의 시험을 보았다. 평균의 차이가 있는가?
pair<-read.csv("../data/onewaySample.csv",header=T)
View(pair)
pair[,"X"]<-NULL
View(pair)

means <- c(mean(pair$score0), mean(pair$score1), mean(pair$score3), mean(pair$score6))
means
plotCI(x=means, type="l")
plot(means, type="o", lty=2, col=2)


multimodel <- lm(cbind(pair$score0,pair$score1,pair$score3,pair$score6) ~ 1)
trials <- factor(c("score0","score1","score3","score6"), ordered=F)
model1 <- Anova(multimodel, idata=data.frame(trials), idesign = ~ trials, type="III")
summary(model1, multvariate=F)

ow <- melt(pair, id.vars="id")
View(ow)

#library(tidyr)
#owlong <- gather(pair, key="ID", value="socre")
#View(owlong)
#owlong<-owlong[8:35,]#ID값 제거

colnames(ow) <- c("id", "score", "value")
ow.mean <- ow %>% group_by(score) %>% summarise(mean=mean(value),sd=sd(value))

out <- aov(value ~ score + Error(id/score), data=ow)
summary(out)
shapiro.test(resid(out))
with(ow, pairwise.t.test(value, score, paired = T, 
                          p.adjust.method = "bonferroni"))

#with(ow, pairwise.t.test(score, ID, paired = T, 
#                       p.adjust.method = "bonferroni"))



ow$id <- factor(ow$id)
ow$score <- factor(ow$score)
ggplot(ow, aes(score, value)) + geom_line(aes(group=id, col=id)) + geom_point(aes(col=id)) 

 
##### 실습 2 : 비모수일경우(써열변수이거나 정규분포가 아닌 경우) #####
#Paired T-Test : Wilcoxen signed rank test
#Rm anova : Friedman test (굉장히 드문 경우)
?friedman.test
RoundingTimes <-
  matrix(c(5.40, 5.50, 5.55,
           5.85, 5.70, 5.75,
           5.20, 5.60, 5.50,
           5.55, 5.50, 5.40,
           5.90, 5.85, 5.70,
           5.45, 5.55, 5.60,
           5.40, 5.40, 5.35,
           5.45, 5.50, 5.35,
           5.25, 5.15, 5.00,
           5.85, 5.80, 5.70,
           5.25, 5.20, 5.10,
           5.65, 5.55, 5.45,
           5.60, 5.35, 5.45,
           5.05, 5.00, 4.95,
           5.50, 5.50, 5.40,
           5.45, 5.55, 5.50,
           5.55, 5.55, 5.35,
           5.45, 5.50, 5.55,
           5.50, 5.45, 5.25,
           5.65, 5.60, 5.40,
           5.70, 5.65, 5.55,
           6.30, 6.30, 6.25),
         nrow = 22,
         byrow = TRUE,
         dimnames = list(1 : 22,
                         c("Round Out", "Narrow Angle", "Wide Angle")))
View(RoundingTimes)

rt <- melt(RoundingTimes)
rt

out<-aov(value ~ Var2, data=rt)
shapiro.test(resid(out))

boxplot(value ~ Var2, data=rt)

friedman.test(RoundingTimes)

#사후검증
#https://www.r-statistics.com/2010/02/post-hoc-analysis-for-friedmans-test-r-code/

install.packages("coin")
library(coin)
friedman.test.with.post.hoc <- function(formu, data, to.print.friedman = T, to.post.hoc.if.signif = T,  to.plot.parallel = T, to.plot.boxplot = T, signif.P = .05, color.blocks.in.cor.plot = T, jitter.Y.in.cor.plot =F)
{
  # formu is a formula of the shape:     Y ~ X | block
  # data is a long data.frame with three columns:    [[ Y (numeric), X (factor), block (factor) ]]
  # Note: This function doesn't handle NA's! In case of NA in Y in one of the blocks, then that entire block should be removed.
  # Loading needed packages
  if(!require(coin))
  {
    print("You are missing the package 'coin', we will now try to install it...")
    install.packages("coin")
    library(coin)
  }
  if(!require(multcomp))
  {
    print("You are missing the package 'multcomp', we will now try to install it...")
    install.packages("multcomp")
    library(multcomp)
  }
  if(!require(colorspace))
  {
    print("You are missing the package 'colorspace', we will now try to install it...")
    install.packages("colorspace")
    library(colorspace)
  }
  # get the names out of the formula
  formu.names <- all.vars(formu)
  Y.name <- formu.names[1]
  X.name <- formu.names[2]
  block.name <- formu.names[3]
  if(dim(data)[2] >3) data <- data[,c(Y.name,X.name,block.name)]    # In case we have a "data" data frame with more then the three columns we need. This code will clean it from them...
  # Note: the function doesn't handle NA's. In case of NA in one of the block T outcomes, that entire block should be removed.
  # stopping in case there is NA in the Y vector
  if(sum(is.na(data[,Y.name])) > 0) stop("Function stopped: This function doesn't handle NA's. In case of NA in Y in one of the blocks, then that entire block should be removed.")
  # make sure that the number of factors goes with the actual values present in the data:
  data[,X.name ] <- factor(data[,X.name ])
  data[,block.name ] <- factor(data[,block.name ])
  number.of.X.levels <- length(levels(data[,X.name ]))
  if(number.of.X.levels == 2) { warning(paste("'",X.name,"'", "has only two levels. Consider using paired wilcox.test instead of friedman test"))}
  # making the object that will hold the friedman test and the other.
  the.sym.test <- symmetry_test(formu, data = data,    ### all pairwise comparisons
                                teststat = "max",
                                xtrafo = function(Y.data) { trafo( Y.data, factor_trafo = function(x) { model.matrix(~ x - 1) %*% t(contrMat(table(x), "Tukey")) } ) },
                                ytrafo = function(Y.data){ trafo(Y.data, numeric_trafo = rank, block = data[,block.name] ) }
  )
  # if(to.print.friedman) { print(the.sym.test) }
  if(to.post.hoc.if.signif)
  {
    if(pvalue(the.sym.test) < signif.P)
    {
      # the post hoc test
      The.post.hoc.P.values <- pvalue(the.sym.test, method = "single-step")    # this is the post hoc of the friedman test
      # plotting
      if(to.plot.parallel & to.plot.boxplot)    par(mfrow = c(1,2)) # if we are plotting two plots, let's make sure we'll be able to see both
      if(to.plot.parallel)
      {
        X.names <- levels(data[, X.name])
        X.for.plot <- seq_along(X.names)
        plot.xlim <- c(.7 , length(X.for.plot)+.3)    # adding some spacing from both sides of the plot
        if(color.blocks.in.cor.plot)
        {
          blocks.col <- rainbow_hcl(length(levels(data[,block.name])))
        } else {
          blocks.col <- 1 # black
        }
        data2 <- data
        if(jitter.Y.in.cor.plot) {
          data2[,Y.name] <- jitter(data2[,Y.name])
          par.cor.plot.text <- "Parallel coordinates plot (with Jitter)"
        } else {
          par.cor.plot.text <- "Parallel coordinates plot"
        }
        # adding a Parallel coordinates plot
        matplot(as.matrix(reshape(data2,  idvar=X.name, timevar=block.name,
                                  direction="wide")[,-1])  ,
                type = "l",  lty = 1, axes = FALSE, ylab = Y.name,
                xlim = plot.xlim,
                col = blocks.col,
                main = par.cor.plot.text)
        axis(1, at = X.for.plot , labels = X.names) # plot X axis
        axis(2) # plot Y axis
        points(tapply(data[,Y.name], data[,X.name], median) ~ X.for.plot, col = "red",pch = 4, cex = 2, lwd = 5)
      }
      if(to.plot.boxplot)
      {
        # first we create a function to create a new Y, by substracting different combinations of X levels from each other.
        subtract.a.from.b <- function(a.b , the.data)
        {
          the.data[,a.b[2]] - the.data[,a.b[1]]
        }
        temp.wide <- reshape(data,  idvar=X.name, timevar=block.name,
                             direction="wide")     #[,-1]
        wide.data <- as.matrix(t(temp.wide[,-1]))
        colnames(wide.data) <- temp.wide[,1]
        Y.b.minus.a.combos <- apply(with(data,combn(levels(data[,X.name]), 2)), 2, subtract.a.from.b, the.data =wide.data)
        names.b.minus.a.combos <- apply(with(data,combn(levels(data[,X.name]), 2)), 2, function(a.b) {paste(a.b[2],a.b[1],sep=" - ")})
        the.ylim <- range(Y.b.minus.a.combos)
        the.ylim[2] <- the.ylim[2] + max(sd(Y.b.minus.a.combos))    # adding some space for the labels
        is.signif.color <- ifelse(The.post.hoc.P.values < .05 , "green", "grey")
        boxplot(Y.b.minus.a.combos,
                names = names.b.minus.a.combos ,
                col = is.signif.color,
                main = "Boxplots (of the differences)",
                ylim = the.ylim
        )
        legend("topright", legend = paste(names.b.minus.a.combos, rep(" ; PostHoc P.value:", number.of.X.levels),round(The.post.hoc.P.values,5)) , fill =  is.signif.color )
        abline(h = 0, col = "blue")
      }
      list.to.return <- list(Friedman.Test = the.sym.test, PostHoc.Test = The.post.hoc.P.values)
      if(to.print.friedman) {print(list.to.return)}
      return(list.to.return)
    }    else {
      print("The results where not significant, There is no need for a post hoc test")
      return(the.sym.test)
    }
  }
  # Original credit (for linking online, to the package that performs the post hoc test) goes to "David Winsemius", see:
  # http://tolstoy.newcastle.edu.au/R/e8/help/09/10/1416.html
}

friedman.test.with.post.hoc(value ~ Var2 | Var1, rt)
#오차 증가값 고정 bonferni

0.05/3 
#0.016보다 작아야 대립가설

##### 사례 4 : Two way Repeated mesured ANOVA #####
df <- read.csv("../data/10_rmanova.csv", header=T)
df

#데이터를 롱형으로 바꾸기
df1<-reshape(df, direction = "long", varying = 3:6, sep = "" )
df1
df2<- melt(df, id=c("group","id"),variable.name = "time",value.name = "month")
df2

# 그래프 확인 작업을 위해 factor 변환 
df1$group<-factor(df1$group)
df1$id <- factor(df1$id)
df1$time <- factor(df1$time)
str(df1) 

interaction.plot(df1$time, df1$group, df1$month)

out<-aov(month~group*time + Error(id), data=df1)
summary(out)


# 사후 검정 
# 데이터를 시점별로 쪼개주는 작업
df_0<-df1[df1$time == "0", ]
df_1<-df1[df1$time == "1", ]
df_3<-df1[df1$time == "3", ]
df_6<-df1[df1$time == "6", ]

df_0
df_1
df_3
df_6

t.test(month ~ group, data=df_0)
t.test(month ~ group, data=df_1)
0.05/6  #6 4C2 종속변수C독립변수
t.test(month ~ group, data=df_3)

t.test(month ~ group, data=df_6)

#최소한 3개월 이상 투약해야 유의미한 결과가 있다. 

















