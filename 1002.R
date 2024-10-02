library(ggplot2)
# CDnow 데이터 소스 위치
url = "https://raw.githubusercontent.com/cran/BTYD/master/data/cdnowElog.csv"
# 데이터 읽기
data = read.csv(url, header=T)

# 데이터 앞부분 출력
head(data)

# quantity 설정
quantity = data$cds

k = nclass.Sturges(quantity)  # Sturges의 공식으로 bin 수 계산

# 히스토그램 그리기
ggplot(data = data, aes(x = quantity)) +
  geom_histogram(col = "black", fill = "gray", bins = k) +
  labs(title = "거래량에 따른 빈도수", x = "거래량", y = "빈도수")

# 그래프 애니메이션
# 막대그래프 애니메이션: 분기별로 막대의 색상이 변경되는 애니메이션
install.packages("gganimate")
install.packages("gifski")
library(gganimate)
library(ggplot2)
library(gifski)

# 데이터셋: 영업팀별 분기별 영업실적 데이터셋
# 1분기 데이터프레임
dept = c("영업1팀", "영업2팀", "영업3팀")
sales = c(12, 5, 8)
df1 = data.frame(부서 = dept, 매출 = sales, 분기 = "1분기")
df1

# 2분기 데이터프레임
sales = c(10, 5, 8)
df2 = data.frame(부서 = dept, 매출 = sales, 분기 = "2분기")
df2

# 1분기와 2분기 데이터프레임을 행으로 연결
df = rbind(df1, df2)
df

# 막대그래프 그리기
anim = ggplot(df, aes(x = 부서, y = 매출, fill = 분기)) +
  geom_bar(stat = "identity") +
  labs(title = "부서별 분기별 영업실적") +
  transition_states(분기)

# 애니메이션 효과 설정 및 실행
animate(anim, width = 300, height = 200,
        duration = 3, # 시간 단위 3초
        renderer = gifski_renderer(loop = FALSE)) # TRUE면 반복, loop에 숫자 대입하면 그에 해당하는 숫자만큼 실행됨

# 애니메이션으로 ENCODING된 그래프를 GIF 형식의 이미지로 저장하는 방법
anim_save("분기별 부서별 영업실적.gif", path = 'D:/박효제/2-2/R_Script/anim') # null로 하면 RSript가 있는 폴더로 저장됨. 따로 저장하려면 경로 지정해야됨.

# 데이터셋: 기본제공되는 iris
iris

# 산포도 그리기
ggplot(data = iris, aes(x = Sepal.Length, y = Sepal.Width, fill = Species, color = Species)) +
  geom_point(size = 3, alpha = 0.5) + # 알파값은 투명도의 정도 나타냄
  labs(title = "꽃받침크기와 종의 분포도", x = "꽃받침길이", y = "꽃받침너비")

# 애니메이션 설정과 실행
anim = ggplot(data = iris, aes(x = Sepal.Length, y = Sepal.Width, fill = Species, color = Species)) +
  geom_point(size = 3, alpha = 0.5) + # 알파값은 투명도의 정도 나타냄
  labs(title = "꽃받침크기와 종의 분포도", x = "꽃받침길이", y = "꽃받침너비") +
  transition_states(Species)

# 애니메이션 실행
animate(anim, width = 400, height = 300,
        duration = 3,
        renderer = gifski_renderer(loop = FALSE))

# 저장
anim_save("꽃받침크기와 종의 분포도.gif", path = 'D:/박효제/2-2/R_Script/anim')

# 선그래프 애니메이션 그리기
# 선그래프: 시간에 따라 데이터의 추이를 살필 때 사용

# 영업1팀의 6개월간 데이터를 데이터프레임에 저장
month = c(1, 2, 3, 4, 5, 6)
sales = c(3, 3, 5, 5, 7, 4)
df1 = data.frame(부서="영업1팀", 월=month, 매출=sales)

# 영업2팀의 6개월간 데이터를 데이터프레임에 저장
sales = c(2, 2, 4, 8, 9, 6)
df2 = data.frame(부서="영업2팀", 월=month, 매출=sales)

# 행으로 df1과 df2를 연결
df = rbind(df1, df2)
df

ggplot(data = df, aes(x = 월, y = 매출, group = 부서)) +
  geom_line(aes(color = 부서), size = 2) +
  geom_point(aes(color = 부서), size = 5, alpha = 0.5)

# 선그래프 그리기
anim = ggplot(data = df, aes(x = 월, y = 매출, group = 부서)) +
  geom_line(aes(color = 부서), size = 2) +
  geom_point(aes(color = 부서), size = 5, alpha = 0.5) +
  labs(title = "부서별 월별 매출액", x = "월", y = "매출액(억원)") +
  transition_reveal(월)

# 선그래프 애니메이션 설정과 실행
animate(anim, width = 500, height = 400,
       duration = 10,
       renderer = gifski_renderer(loop = FALSE))