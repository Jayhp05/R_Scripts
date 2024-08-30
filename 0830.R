# install된 패키지들
pkg=installed.packages()
pkg

# 패키지 설치된 경로
.libPaths()

# 데이터셋 종류 확인
data(package="datasets")

# 직사각형의 면적을 구하는 함수 정의
getRectangleArea = function(w, h){
  area = w * h
  return(area)
}

w = 20
h = 35

# 함수호출
getRectangleArea(w, h)

# 3장 데이터 구조
# 벡터: 선형으로 1개 이상의 숫자 또는 문자열들을 저장가능
# index는 자바와 다르게 1번부터 시작
# 여러개의 데이터를 저장할 때 c()함수 사용

score = 80
score

score=c(95, 78, 92)
score

score[2] = 88
score[4] = 100
score

name = c("장발장", "팡틴", "코제트")
name

name[4] = "자베르"

name

# 연속적인 값들을 벡터에 저장
# sequence 함수 사용
x1 = seq(1, 100, by=10)
x1

# 1씩 증가하는 값 저장
x2 = 1:10
seq(1, 10, by="1")
x2

# 1씩 감소하는 값 저장
x3 = 10:1
seq(10, 1, by=-1)
x3

# 저장되는 값의 길이(개수)를 지정해서 동일하게 분배된 값을 저장
x4 = seq(0, 10, length.out=5)
x4

# 반복(repeat) 함수: rep(), times, each 속성
x5 = c(1, 2, 3)
y1 = rep(x5, times = 3)
y1

x6 = c(1, 2, 3)
y2 = rep(x6, each = 3)
y2

# 연산자

# 산술연산자
# 거듭제곱(제곱승) 연산자
10^3

a = 5
b = 5

r1 = a^b
r1

x = c(10, 20, 30, 40)
y = c(1, 6, 11, 16)
w = c(100, 200)

x+5
x+y
# 벡터 개수가 다를 때는 개수가 작은 쪽의 인덱스를 반복해서 연산한다
x+w

# 비교연산자: 비교연산의 결과는 논리값 TURE, FALSE로 결과가 나타남

a = 7
b = 10

a > b

x = c(10, 20, 30)
x <= 10 #X의 전체 값들에 대해 비교값이 나옴

# 벡터에 있는 요소의 값들 중에 하나라도 비교연산 결과에 True가 있으면 결과는 True
any(x <= 10)

# 벡터에 있는 요소의 값들이 비교연산 결과에 모두 True가 되어야 결과는 True
all(x <= 10)

# 벡터에서 20 이상인 요소를 반환
x[x >= 20]

# 논리연산자: TRUE, FALSE로 결과를 반환
x = c(TRUE, TRUE, FALSE, FALSE)
y = c(TRUE, FALSE, TRUE, FALSE)

x | y
x & y
xor(x, y) # 서로 다른 값일 때: TRUE, 서로 같으면: FALSE

!x # not연산자: 반대 논리값을 반환

# NA(Not Available(결측치): 누락된 경우)
# NULL(변수를 선언하고 초기화하지 않았을 때)
# Inf(Infinity: 0이 아닌 숫자를 0으로 나누었을 때)
# NaN(Not a Number: 0을 0으로 나누었을 때 발생)

z = NULL
z
is.null(z)

k
is.null(k) # k를 찾지 못해서 오류가 발생, 벡터에 값을 넣지 않을 때는 NULL로 대입해야함

y = c(1, 2, 3, NA, 5)
y

z = 5/0
z

t = 0/0
t

# 요인(factor)
# 벡터에 저장된 동일한 값들을 요인으로 찾아내서 대표값들을 분류해서 반환 + 기존에 있던 벡터값들 까지 함께 반환
gender = c("여", "남", "남", "여", "여", "남")
gender

gender.factor = factor(gender)
gender.factor