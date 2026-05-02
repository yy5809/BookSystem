package com.ruoyi.textbook.domain.dto;

import com.ruoyi.common.annotation.Excel;
import javax.validation.constraints.NotBlank;
import javax.validation.constraints.Size;

public class TeacherImportDTO {

    @Excel(name = "姓名", sort = 0, width = 15)
    @NotBlank(message = "姓名不能为空")
    @Size(max = 30, message = "姓名长度不能超过30")
    private String nickName;

    @Excel(name = "职工号", sort = 1, width = 20)
    @NotBlank(message = "职工号不能为空")
    @Size(max = 30, message = "职工号长度不能超过30")
    private String userName;

    @Excel(name = "密码", sort = 2, width = 15)
    @NotBlank(message = "密码不能为空")
    @Size(min = 5, max = 20, message = "密码长度必须介于5和20之间")
    private String password;

    @Excel(name = "所属部门", sort = 3, width = 25,
           combo = "环境科学与工程学院,智能制造学院,土木工程学院,管理学院,艺术学院,语言文化学院,公共教学部,马克思主义学院")
    @NotBlank(message = "所属部门不能为空")
    private String deptName;

    public String getNickName() {
        return nickName;
    }

    public void setNickName(String nickName) {
        this.nickName = nickName;
    }

    public String getUserName() {
        return userName;
    }

    public void setUserName(String userName) {
        this.userName = userName;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public String getDeptName() {
        return deptName;
    }

    public void setDeptName(String deptName) {
        this.deptName = deptName;
    }
}
