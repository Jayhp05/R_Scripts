# 8장 공공데이터 활용
# 공공데이터 활용신청한 url
install.packages("XML")
install.packages("httr")
install.packages("xml2")

library(XML)
library(httr)
library(xml2)

api = "https://apis.data.go.kr/B552584/ArpltnStatsSvc/getCtprvnMesureLIst"

api_key = "KPXkp9A5jCelRkUuOvT3EfPP0nOgvtQUiRySPCUmIPHtzYSE6G9%2FvLanfYwDPYz6JfL2K6HaXTIMOLyW1c3zwA%3D%3D"

returnType = "xml"
numOfRows	= 10
pageNo = 1
itemCode = "PM10"
dataGubun = "HOUR"
searchCondition = "MONTH"

url = paste0(api, "?serviceKey=", api_key, 
             "&returnTypev", returnType,
             "&numOfRows=", numOfRows, 
             "&pageNo=", pageNo, 
             "&itemCode=", itemCode, 
             "&dataGubun=", dataGubun, 
             "&searchCondition=", searchCondition)

url

url2 = "https://apis.data.go.kr/B552584/ArpltnStatsSvc/getCtprvnMesureLIst?serviceKey=KPXkp9A5jCelRkUuOvT3EfPP0nOgvtQUiRySPCUmIPHtzYSE6G9%2FvLanfYwDPYz6JfL2K6HaXTIMOLyW1c3zwA%3D%3D&returnType=xml&numOfRows=100&pageNo=1&itemCode=PM10&dataGubun=HOUR&searchCondition=MONTH"

response = GET(url)
content = content(response, "text")

xmlFile = xmlParse(content, asText = TRUE)
xmlFile

# XML => 데이터프레임으로 변환
df = xmlToDataFrame(getNodeSet(xmlFile, "//items/item"))
df

library(ggplot2)

# df에서 필요한 데이터만 추출
# 제공되는 미세먼지 데이터 중에서 마지막 시간의 데이터가 1행이고 지역이 연속적이지
# 않기 때문에 아래와 같은 데이터 추출이 필요
pm = df[1, c(1:16, 19)]
pm

# 지역별 미세먼지 데이터프레임의 행과 열을 바꾸기
pm.region = t(pm)
pm.region

# 행과 열로 표시된 데이터를 데이터프레임으로 변환
df.region = as.data.frame(pm.region)
df.region

# 1로 설정된 컬럼이름을 PM10 컬럼명으로 변경
colnames(df.region) = "PM10"
df.region

# df.region에 컬럼추가(컬럼명: name, 값: 한글지면)
df.region$NAME = c("대구광역시", "충청남도", "인천광역시", "대전광역시", "경상북도", "세종특별자치시", "광주광역시",
                   "전라북도", "강원도", "울산광역시", "전라남도", "서울특별시", "부산광역시", "제주특별자치도", "충청북도",
                   "경상남도", "경기도")

df.region

install.packages("sf")
library(sf)
library(dplyr)

# 행정경계 데이터셋(shape[.shp] 파일) 읽어오기
map = st_read("D:/박효제/2-2/R_Script/행정경계데이터셋/Z_NGII_N3A_G0010000.shp", options = "ENCODING=EUC-KR")
map

# WGS84 좌표계
crs_wgs84 = st_crs(4326)

# WGS84 좌표계로 map을 변환
map_sf = st_transform(map, crs_wgs84)
map_sf

# sf객체를 데이터프레임으로 변환
df_map = st_as_sf(map_sf)
df_map

# 지형정보 확인
st_geometry(map)

# df_map 데이터프레임의 구조 확인
str(df_map)

# 그룹화 변수 확인
table(df_map$id)
names(str(df_map))

# 경도와 위도를 추출해서 저장
# 현재 df_map이 유효한 데이터임을 증명
df_map = st_make_valid(df_map)
df_map

# 지도를 그리기 위한 전체 경도와 위도 데이터셋 1108 - 11:26분경 추가함
df_map2 = st_make_valid(map_sf)
total_longlat = df_map %>%
  summarise(geometry = st_centroid(st_union(geometry)), .groups="drop") %>% # summarise = 요약하고 축약하는 기능
  mutate(long=st_coordinates(geometry)[, 1], # 1열 사용
         lat=st_coordinates(geometry)[, 2]) # 2열 사용

total_longlat

# id(UFID)를 기준으로 그룹화
longlat = df_map %>% group_by(UFID) %>%
  summarise(geometry = st_centroid(st_union(geometry)), .groups="drop") %>% # summarise = 요약하고 축약하는 기능
  mutate(long=st_coordinates(geometry)[, 1], # 1열 사용
         lat=st_coordinates(geometry)[, 2] # 2열 사용
         )

longlat

# 경도위도 데이터셋의 결과를 데이터프레임으로 변환
longlat_df = longlat %>% st_drop_geometry() %>% as.data.frame()

longlat_df
str(longlat_df)
longlat_df
df.region

# 공간정보 데이터프레임에서 기하학적 정보를 제거하는 기능
df_map_info = st_drop_geometry(df_map)
df_map_info

longlat = cbind(longlat, NAME=df_map_info[, 3])
longlat

df.PM10 = merge(x=df.region, y=longlat, by="NAME", all=TRUE)
df.PM10

# df.PM10이 long, lat 컬럼이 좌표 정보를 담고 있다면
################################################################
df.PM10 = st_as_sf(df.PM10, coords = c("long", "lat"), crs = 4326)
df.PM10 = st_transform(df.PM10, st_crs(map))
################################################################

library(ggplot2)
total_longlat

ggplot() +   # 주석 단축키 = ctrl + shift + c
#  geom_sf(data=map,
#          fill="white",
#          alpha=0.5,
#          color="black") +
  geom_polygon(data=total_longlat,
               aes(x=long, y=lat),
               fill="white",
               alpha=0.5,
               color="black") +
  geom_point(data = df.PM10, aes(x=long, y=lat, size = PM10),
             shape=21, color="black", fill="red", alpha=0.3) +
  theme(legend.position = "none") +
  labs(title = "PM10 농도 분포", x="경도", y="위도")

ggplot() +   # 주석 단축키 = ctrl + shift + c
   geom_sf(data=map,
           fill="white",
           alpha=0.5,
           color="black") +
  geom_point(data = df.PM10, aes(x=coordinates(geometry)[, 1], y=st_coordinates(geometry)[, 2], size = PM10),
             color="red", alpha=0.3) +
  theme(legend.position = "none") +
  labs(title = "PM10 농도 분포", x="경도", y="위도")