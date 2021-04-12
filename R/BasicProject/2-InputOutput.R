##### 키보드 입력 #####
# scan() : 벡터 입력 - 콘솔에 입력
# edit() : 데이터 프레임을 입력 받을 때 

a <- scan() #숫자를 입력(엔터). 그만 입력할 경우 빈칸에 엔터
a

b<- scan(what=character())
b

df<- data.frame()
df<-edit(df)
df





##### 파일 입력 ######
# read.csv()
# read.table() #,로 구분된 파일을 제외한 모든 파일
# read.xlsx()
student<-read.table("../data/student.txt")
student
student1<-read.table("../data/student1.txt",header=T)
student1

student2<- read.table(file.choose(),header = T,sep=";")  #창이 열리고 파일 선택
student2

student3<-  read.table("../data/student3.txt",header=T, sep="", 
                       na.strings = "-")
student3<-  read.table("../data/student3.txt",header=T, sep="", 
                       na.strings = c("-","+","&"))
student3

#read.xlsx() 기본으로 제공되는 함수가 아니다(파이썬 pip같은 외부 라이브러리) p.41
#패키지 설치
install.packages("xlsx")

library(rJava)
library(xlsx)

#studentX<-read.xlsx(file.choose(), sheetIndex = 1, encoding = "UTF-8")
studentX<-read.xlsx(file.choose(), sheetName = "emp2", encoding = "UTF-8")
studentX


##### 화면 출력 #####
# 변수명
# ()
# cat()
# print()

x<-10
y<-20
z<-x+y

z
(z<-x+y)
print(z<-x+y)
print(z)
#print("x+y의 결과는" + as.character(z) + "입니다.") #+는 무조건 숫자계산에서만 사용
#print("x+y의 결과는", as.ccharacter(z), "입니다.") #,도 사용불가
#print 대신 cat 사용하면 출력할 수 있다.
cat("x+y의 결과는", as.character(z), "입니다.")


##### 파일 출력 #####
# write.table()
# write.csv()

studentX<-read.xlsx(file.choose(), sheetName = "emp2", encoding = "UTF-8")
studentX
class(studentX)

write.table(studentX, "../data/stud1.txt")
write.table(studentX, "../data/stud2.txt", row.names = F)
write.table(studentX, "../data/stud3.txt", row.names = F, quote=F) #데이터의""삭제
write.csv(studentX, "../data/stud4.txt", row.names = F, quote=F) #자동으로 ,

library(rJava)
library(xlsx)

write.xlsx(studentX, "../data/stud5.xlsx")

##### rda 파일 출력 #####
#save() R 데이터 형식 / 2진수로 저장 / R에서만 볼 수 있게 / 처리 속도가 빠름
#load()

save(studentX, file="../data/stud6.rda")
rm(studentX) 
studentX

load("../data/stud6.rda")
studentX

##### sink()####
data()
?data

data(iris)
head(iris)
tail(iris)
iris
str(iris)
#sink 실행하고 나서부터는 결과가 화면에 출력되지 않고 파일에 저장
sink("../data/iris.txt") 
head(iris)
tail(iris)
str(iris)
#중지하고 싶을때는 다시하번 sink()
sink()
head(iris)
