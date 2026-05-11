package com.ruoyi.textbook.util;

import java.util.regex.Matcher;
import java.util.regex.Pattern;

/**
 * 年级/入学年份换算工具
 * 
 * 核心逻辑：
 *   存储：入学年份（如"22级"=2022年入学，固定不变）
 *   换算：年级 = currentAcademicYear - enrollmentYear + 1
 *   展示：软件工程22-1班 (22级/大四)
 */
public class GradeConverter {

    private static final String[] GRADE_NAMES = {"大一", "大二", "大三", "大四"};

    /**
     * 从班级名称提取入学年份（公元4位）
     * 软件工程22-1班 → 2022
     * 计科2023-2班   → 2023
     * 通用           → null
     */
    public static Integer extractEnrollmentYear(String className) {
        if (className == null || className.isEmpty()) return null;
        if ("通用".equals(className)) return null;

        // 先尝试匹配4位年份
        Pattern p4 = Pattern.compile("(20\\d{2})");
        Matcher m4 = p4.matcher(className);
        if (m4.find()) {
            return Integer.parseInt(m4.group(1));
        }

        // 再尝试匹配2位缩写（如22级、23级）
        Pattern p2 = Pattern.compile("(\\d{2})级");
        Matcher m2 = p2.matcher(className);
        if (m2.find()) {
            int shortYear = Integer.parseInt(m2.group(1));
            return shortYear >= 50 ? 1900 + shortYear : 2000 + shortYear;
        }

        // 从班级名称末尾提取2位数字（软件工程22-1班中的22）
        Pattern pEnd = Pattern.compile(".*?(\\d{2})-\\d+班?$");
        Matcher mEnd = pEnd.matcher(className);
        if (mEnd.find()) {
            int shortYear = Integer.parseInt(mEnd.group(1));
            return shortYear >= 50 ? 1900 + shortYear : 2000 + shortYear;
        }

        return null;
    }

    /**
     * 从"22级"格式字符串提取入学年份
     * "22级" → 2022, "2022" → 2022, null → null
     */
    public static Integer parseEnrollmentYear(String gradeLevel) {
        if (gradeLevel == null || gradeLevel.isEmpty() || "通用".equals(gradeLevel)) return null;
        
        Pattern p4 = Pattern.compile("(20\\d{2})");
        Matcher m4 = p4.matcher(gradeLevel);
        if (m4.find()) return Integer.parseInt(m4.group(1));

        Pattern p2 = Pattern.compile("(\\d{2})级?");
        Matcher m2 = p2.matcher(gradeLevel);
        if (m2.find()) {
            int shortYear = Integer.parseInt(m2.group(1));
            return shortYear >= 50 ? 1900 + shortYear : 2000 + shortYear;
        }
        return null;
    }

    /**
     * 入学年份 → 年级名称（基于当前学年动态计算）
     * 2022 + currentAcademicYear=2026 → "大四"
     */
    public static String toGradeName(Integer enrollmentYear, int currentAcademicYear) {
        if (enrollmentYear == null) return "通用";
        int grade = currentAcademicYear - enrollmentYear + 1;
        if (grade >= 1 && grade <= 4) return GRADE_NAMES[grade - 1];
        return grade > 4 ? "大四(毕业班)" : "大" + grade;
    }

    /**
     * 构建班级展示文本
     * "软件工程22-1班" + "22级" → "软件工程22-1班 (22级/大三)"
     */
    public static String toDisplayName(String className, String gradeLevel, int currentAcademicYear) {
        Integer year = parseEnrollmentYear(gradeLevel);
        if (year == null) year = extractEnrollmentYear(className);
        if (year == null) return className == null ? "" : className;

        String shortYear = String.valueOf(year).substring(2);
        String gradeName = toGradeName(year, currentAcademicYear);
        return className + " (" + shortYear + "级/" + gradeName + ")";
    }

    /**
     * 年级名 → 入学年份（反向推算，用于兼容旧"大一/大二"数据）
     * "大一" + currentAcademicYear=2026 → 2026（大一 = 当年入学）
     */
    public static Integer gradeNameToEnrollmentYear(String gradeName, int currentAcademicYear) {
        if (gradeName == null || gradeName.isEmpty() || "通用".equals(gradeName)) return null;
        for (int i = 0; i < GRADE_NAMES.length; i++) {
            if (GRADE_NAMES[i].equals(gradeName)) {
                return currentAcademicYear - i;
            }
        }
        return parseEnrollmentYear(gradeName);
    }

    /**
     * 旧"大一/大二"格式 → 新"22级"格式
     */
    public static String normalizeGradeLevel(String gradeLevel, int currentAcademicYear) {
        if (gradeLevel == null || "通用".equals(gradeLevel)) return gradeLevel;
        Integer year = parseEnrollmentYear(gradeLevel);
        if (year != null) return String.valueOf(year).substring(2) + "级";

        Integer computed = gradeNameToEnrollmentYear(gradeLevel, currentAcademicYear);
        if (computed != null) return String.valueOf(computed).substring(2) + "级";
        return gradeLevel;
    }
}
