# 시각화
library(ggplot2)

set.seed(Sys.time())  # 현재 시간을 시드로 설정

initial_investment = 1000  # 초기 투자금
mean_return = 0.07  # 연평균 7% 수익률
std_deviation = 0.15  # 연평균 15% 표준편차
years = 10  # 기간 10년
simulations = 10000  # 시뮬레이션 횟수

earnings_rate_values = matrix(0, nrow = simulations, ncol = years)

for (i in 1:simulations) {
  annual_returns = rnorm(years, mean_return, std_deviation)  # 연도별 수익률 생성
  earnings_rate_values[i, ] = initial_investment * cumprod(1 + annual_returns)  # 누적 수익 계산
}

# 최종 수익률 값 계산
mean_final_value = mean(earnings_rate_values[, years])
median_final_value = median(earnings_rate_values[, years])
std_final_value = sd(earnings_rate_values[, years])

c("평균 최종 수익률 가치: $", round(mean_final_value, 2), "\n")
c("중앙값 최종 수익률 가치: $", round(median_final_value, 2), "\n")
c("최종 수익률 가치의 표준편차: $", round(std_final_value, 2), "\n")

# 연도별 누적 수익률 가치 계산
cumulative_earnings_rate_values = apply(earnings_rate_values, 1, function(x) cumsum(x))

# 데이터프레임으로 변환
df_cumulative = data.frame(
  Year = rep(1:years, simulations),
  CumulativeValue = as.vector(cumulative_earnings_rate_values)
)

ggplot(df_cumulative, aes(x = Year, y = CumulativeValue, group = 1)) +
  geom_line(color = "blue", size = 1) +
  geom_point() +
  labs(title = "연도별 누적 수익률 가치 변화", x = "n년 후", y = "누적 수익률 가치 ($)") +
  theme_minimal()