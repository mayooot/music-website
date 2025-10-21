package com.example.yin.controller;

import io.minio.GetObjectArgs;
import io.minio.MinioClient;
import io.minio.StatObjectArgs;
import org.apache.commons.io.IOUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.*;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestHeader;

import javax.servlet.http.HttpServletRequest;
import java.io.InputStream;
import java.util.regex.Matcher;
import java.util.regex.Pattern;


@Controller
public class MinioController {
    @Value("${minio.bucket-name}")
    private String bucketName;
    @Autowired
    private MinioClient minioClient;
    //获取歌曲 - 支持Range请求用于音频流媒体播放
    @GetMapping("/user01/{fileName:.+}")
    public ResponseEntity<byte[]> getMusic(@PathVariable String fileName, 
                                         @RequestHeader(value = "Range", required = false) String rangeHeader,
                                         HttpServletRequest request) {
        try {
            // 获取文件信息
            StatObjectArgs statArgs = StatObjectArgs.builder()
                    .bucket(bucketName)
                    .object(fileName)
                    .build();
            io.minio.StatObjectResponse statObject = minioClient.statObject(statArgs);
            long fileSize = statObject.size();
            
            // 设置响应头
            HttpHeaders headers = new HttpHeaders();
            headers.setContentType(MediaType.APPLICATION_OCTET_STREAM);
            headers.set("Accept-Ranges", "bytes");
            headers.set("Cache-Control", "no-cache");
            
            // 处理Range请求
            if (rangeHeader != null && rangeHeader.startsWith("bytes=")) {
                // 解析Range头
                Pattern pattern = Pattern.compile("bytes=(\\d+)-(\\d*)");
                Matcher matcher = pattern.matcher(rangeHeader);
                
                if (matcher.find()) {
                    long start = Long.parseLong(matcher.group(1));
                    long end = matcher.group(2).isEmpty() ? fileSize - 1 : Long.parseLong(matcher.group(2));
                    
                    // 确保范围有效
                    if (start < 0) start = 0;
                    if (end >= fileSize) end = fileSize - 1;
                    if (start > end) {
                        return new ResponseEntity<>(HttpStatus.REQUESTED_RANGE_NOT_SATISFIABLE);
                    }
                    
                    // 设置Range响应头
                    headers.set("Content-Range", String.format("bytes %d-%d/%d", start, end, fileSize));
                    headers.setContentLength(end - start + 1);
                    
                    // 获取指定范围的数据
                    GetObjectArgs getArgs = GetObjectArgs.builder()
                            .bucket(bucketName)
                            .object(fileName)
                            .offset(start)
                            .length(end - start + 1)
                            .build();
                    
                    InputStream inputStream = minioClient.getObject(getArgs);
                    byte[] bytes = IOUtils.toByteArray(inputStream);
                    inputStream.close();
                    
                    return new ResponseEntity<>(bytes, headers, HttpStatus.PARTIAL_CONTENT);
                }
            }
            
            // 没有Range请求，返回完整文件
            GetObjectArgs args = GetObjectArgs.builder()
                    .bucket(bucketName)
                    .object(fileName)
                    .build();
            InputStream inputStream = minioClient.getObject(args);
            byte[] bytes = IOUtils.toByteArray(inputStream);
            inputStream.close();
            
            headers.setContentLength(fileSize);
            return new ResponseEntity<>(bytes, headers, HttpStatus.OK);
            
        } catch (Exception e) {
            e.printStackTrace();
            return new ResponseEntity<>(HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }
    //获取歌手图片
    @GetMapping("/user01/singer/img/{fileName:.+}")
    public ResponseEntity<byte[]> getImage(@PathVariable String fileName) throws Exception {
        InputStream stream = minioClient.getObject(
                GetObjectArgs.builder()
                        .bucket(bucketName)
                        .object("singer/img/"+fileName)
                        .build()
        );

        byte[] bytes = IOUtils.toByteArray(stream);

        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(MediaType.IMAGE_JPEG); // 设置响应内容类型为图片类型，根据实际情况修改

        return new ResponseEntity<>(bytes, headers, HttpStatus.OK);
    }
    //获取歌单图片
    @GetMapping("/user01/songlist/{fileName:.+}")
    public ResponseEntity<byte[]> getImage1(@PathVariable String fileName) throws Exception {
        InputStream stream = minioClient.getObject(
                GetObjectArgs.builder()
                        .bucket(bucketName)
                        .object("songlist/"+fileName)
                        .build()
        );

        byte[] bytes = IOUtils.toByteArray(stream);

        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(MediaType.IMAGE_JPEG); // 设置响应内容类型为图片类型，根据实际情况修改

        return new ResponseEntity<>(bytes, headers, HttpStatus.OK);
    }
    //获取歌的图片
    ///user01/singer/song/98329722.jfif
    @GetMapping("/user01/singer/song/{fileName:.+}")
    public ResponseEntity<byte[]> getImage2(@PathVariable String fileName) throws Exception {
        InputStream stream = minioClient.getObject(
                GetObjectArgs.builder()
                        .bucket(bucketName)
                        .object("singer/song/"+fileName)
                        .build()
        );

        byte[] bytes = IOUtils.toByteArray(stream);

        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(MediaType.IMAGE_JPEG); // 设置响应内容类型为图片类型，根据实际情况修改

        return new ResponseEntity<>(bytes, headers, HttpStatus.OK);
    }
    //获取头像
    ///img/avatorImages/
    @GetMapping("/img/avatorImages/{fileName:.+}")
    public ResponseEntity<byte[]> getImage3(@PathVariable String fileName) throws Exception {
        InputStream stream = minioClient.getObject(
                GetObjectArgs.builder()
                        .bucket(bucketName)
                        .object("img/avatorImages/"+fileName)
                        .build()
        );

        byte[] bytes = IOUtils.toByteArray(stream);

        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(MediaType.IMAGE_JPEG); // 设置响应内容类型为图片类型，根据实际情况修改

        return new ResponseEntity<>(bytes, headers, HttpStatus.OK);
    }
}
