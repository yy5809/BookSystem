FROM eclipse-temurin:8-jre-focal
ENV TZ=Asia/Shanghai
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
WORKDIR /app
RUN mkdir -p /home/ruoyi/uploadPath
COPY ruoyi-admin/target/ruoyi-admin.jar app.jar
COPY sql/ry-vue.sql /app/sql/ry-vue.sql
EXPOSE 8080
ENV JAVA_OPTS="-Xms256m -Xmx1024m -XX:MetaspaceSize=128m -XX:MaxMetaspaceSize=512m"
ENV SPRING_PROFILES_ACTIVE=druid
ENTRYPOINT java ${JAVA_OPTS} -Dfile.encoding=UTF-8 -jar app.jar