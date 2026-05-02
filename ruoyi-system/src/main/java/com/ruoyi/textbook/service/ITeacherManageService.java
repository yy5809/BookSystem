package com.ruoyi.textbook.service;

import java.util.List;
import com.ruoyi.common.core.domain.entity.SysUser;
import com.ruoyi.textbook.domain.dto.TeacherImportDTO;

public interface ITeacherManageService {

    List<SysUser> selectTeacherList(SysUser user);

    SysUser selectTeacherById(Long userId);

    boolean checkUserNameUnique(SysUser user);

    int insertTeacher(SysUser user);

    int updateTeacher(SysUser user);

    int deleteTeacherByIds(Long[] userIds);

    int resetTeacherPwd(SysUser user);

    int changeTeacherStatus(SysUser user);

    String importTeacher(List<TeacherImportDTO> teacherList, String operName);
}
