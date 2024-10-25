install.packages("leaflet")

library(leaflet)
library(ggplot2)

# leaflet 객체 보여지는 지도의 설정과 오픈스트리트 맵재단에서 제공하는 지도타일 추가
m = leaflet() %>%
  setView(lng = 126.996542, lat = 37.5290615, zoom = 15) %>% w # 제일 큰 zoom값은 18
addTiles()

m

# 지도 중심에 마커 출력하는 방법
m = leaflet() %>%
  addTiles() %>%
  addMarkers(lng = 126.996542, lat = 37.5290615, label = "한국 폴리텍 대학", popup = "서울 정수 캠퍼스 인공지능 소프트웨어")

m

# 오늘 내가 수업 끝난 후 갈 장소를 지도에 출력하고 장소이름은 라벨로 표시하고, 상세주소 또는 전화번호를 팝업으로 표시.
m = leaflet() %>%
  setView(lng = 126.9771397, lat = 37.5366059, zoom = 15) %>% # 전쟁기념관이 중심점이고, 마커는 대통령실
  addTiles() %>%
  addMarkers(lng = 126.9761836, lat = 37.5306468, label = "대한민국 대통령실", popup = "정보제한 사항입니다.") %>%
  addMarkers(lng = 126.9804702, lat = 37.5238506, label = "국립 중앙 박물관", popup = "입장 무료입니다.")

m

quakes

# quakes 데이터셋에 있는 경도, 위도 값을 사용하여 지도타일을 출력
m = leaflet(data = quakes) %>%
  addTiles() %>%
  addCircleMarkers(~long, ~lat, ~mag, stroke = TRUE, weight = 1, color = "black", fillColor = "green", fillOpacity = 0.3)
m

# magnitude(지진규모)의 크기가 6이상이면 반지름을 10으로 설정하고 6미만이면 반지름을 1로 설정한다.
m = leaflet(data = quakes) %>%
  addTiles() %>%
  addCircleMarkers(~long, ~lat, radius = ~ifelse(mag >= 6, 10, 1), stroke = TRUE, weight = 1, color = "black", fillColor = "green", fillOpacity = 0.3)
m

# mag(지진규모)가 5.5 이상이면 반지름을 10, 그렇지 않으면 0
# mag(지진규모)가 5.5 이상이면 테두리선의 굵기를 1, 그렇지 않으면 0
# mag(지진규모)가 5.5 이상이면 불투명도를 0.3, 그렇지 않으면 0
m = leaflet(data = quakes) %>%
  addTiles() %>%
  addCircleMarkers(~long, ~lat, radius = ~ifelse(mag >= 5.5, 10, 0), stroke = TRUE, weight = ~ifelse(mag >= 5.5, 1, 0), color = "black", fillColor = "green", fillOpacity = ~ifelse(mag >= 5.5, 0.3, 0))
m

# mag(지진규모)가 6 이상이면 반지름을 10, 그렇지 않고 5.5 이상이면 5, 그렇지 않으면 0
# mag(지진규모)가 5.5 이상이면 테두리선의 굵기를 1, 그렇지 않으면 0
# mag(지진규모)가 5.5 이상이면 불투명도를 0.3, 그렇지 않으면 0
# mag(지진규모)가 6 배경색을 red, 그렇지 않고 5.5 이상이면 green, 그렇지 않으면 색이 없이 (NA)
m = leaflet(data = quakes) %>%
  addTiles() %>%
  addCircleMarkers(~long, ~lat, radius = ~ifelse(mag >= 6, 10, 0), stroke = TRUE, weight = ~ifelse(mag >= 5.5, 1, 0), color = "black", fillColor = "green", fillOpacity = ~ifelse(mag >= 5.5, 0.3, 0))
m

m <- leaflet(data = quakes) %>%
  addTiles() %>%
  addCircleMarkers(
    ~long, ~lat,
    radius = ~ifelse(mag >= 5.5, 10, 0),  # 지진 규모 5.5 이상이면 반지름 10, 아니면 0
    stroke = TRUE,
    weight = ~ifelse(mag >= 5.5, 1, 0),  # 지진 규모 5.5 이상이면 테두리선 굵기 1, 아니면 0
    color = "black",
    fillColor = ~ifelse(mag >= 6, "red", ifelse(mag >= 5.5, "green", NA)),  # 규모 6 이상은 빨강, 5.5~6은 초록, 나머지는 없음
    fillOpacity= ~ifelse(mag >= 5.5, 0.3, 0)  # 지진 규모 5.5 이상이면 불투명도 0.3, 아니면 0
  )
m

# 행정경계 데이터셋을 사용한 지도 시각화
install.packages("sf")
library(sf)

# 행정경계 데이터셋(shape[.shp] 파일) 읽어오기
df_map = st_read("D:/박효제/2-2/R_Script/행정경계데이터셋/Z_NGII_N3A_G0010000.shp")

ggplot(data = df_map) +
  geom_sf(fill="white", color = "black")

# 행정경계 시도(id)의 배경색을 다르게 지정
# id 설정
if(!"id"%in%names(df_map)) { # id가 포함되어있지 않다면
  df_map$id = 1:nrow(df_map)
}

ggplot(data = df_map) +
  geom_sf(aes(fill=id), alpha=0.3, color = "black") +
  theme(legend.position = "none") +
  labs(x = "경도", y = "위도")

# 지진분포를 지도로 출력
# 데이터셋은 엑셀 파일로 읽어와서 사용
install.packages("openxlsx")

library(openxlsx)

df = read.xlsx("D:/박효제/2-2/R_Script/행정경계데이터셋/국내지진목록.xlsx", sheet = 1, startRow = 4, colNames = FALSE)

head(df)

tail(df)

# X8열에서 북한으로 시작하는 데이터의 행 번호를 추출할 때 사용하는 방법
idx = grep("^북한", df$X8) # ^북한: 북한으로 시작하는

# 북한지역의 X8열의 데이터를 확인
df[idx, 'X8']

# X8열에 북한으로 시작하는 행 삭제
df = df[-idx, ]

# df에 있는 6열과 7열의 데이터 중 N과 E를 삭제하는 방법
df[, 6] = gsub("N", "", df[, 6]) # N의 데이터를 ""로 바꿈. 삭제
df[, 7] = gsub("E", "", df[, 7])

# 6, 7열의 값을 숫자형으로 변환
df[, 6] = as.numeric(df[, 6])
df[, 7] = as.numeric(df[, 7])

df[, 6]

# 행정경계지도와 지진분포 출력
# shape file 읽어오기
map = st_read("D:/박효제/2-2/R_Script/행정경계데이터셋/Z_NGII_N3A_G0010000.shp")

# WGS 84 좌표계로 변환(지도 출력)
map = st_transform(map, crs = 4326)

# 포인트 데이터를 sf객체로 변환(포인트 출력)
df_sf = df%>%st_as_sf(coords = c("X7", "X6"), crs = 4326)

# 행정경계지도 출력
ggplot() +
  geom_sf(data = map, fill = "white", alpha = 0.5, color = "black") +
  geom_sf(data = df_sf, aes(size=X3), shape = 21, fill="red", alpha = 0.3, color="black") +
  theme(legend.position = "none") +
  labs(title = "지진분포", x = "경도", y = "위도")