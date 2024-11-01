# 한국환경공다(https://www.airkorea.or.kr)에서 운영하는 에어코리아 홈페이지에서
# 특정일의 시도별 대기정보인 미세먼지(PM10) 또는 초미세먼지(PM2.5)의 농도를
# 웹스크래핑으로 추출해보자

library(rvest)

url = "https://www.airkorea.or.kr/web/sidoQualityCompare?itemCode=10008&pMENU_NO=102"
html = read_html(url)
html

titles = html_nodes(html, "#sidoTable_thead") %>%
  html_text()

titles

# 특수 문자열들을 ""(empty string)으로 대체
titles = gsub("\r|\n|\t", "", titles)
# 지역 이름이 나오는 머릿글 출력
titles

# 잘 안되네요.
titles2 = html_nodes(html, "#sidoTable tr td") %>%
  html_text()

titles2

titles2 = gsub("\r|\n|\t", "", titles2)
titles2