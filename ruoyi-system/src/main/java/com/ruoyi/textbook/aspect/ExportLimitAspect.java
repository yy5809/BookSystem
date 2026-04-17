package com.ruoyi.textbook.aspect;

import com.ruoyi.common.exception.ServiceException;
import com.ruoyi.textbook.annotation.MaxExportRows;
import org.aspectj.lang.ProceedingJoinPoint;
import org.aspectj.lang.annotation.Around;
import org.aspectj.lang.annotation.Aspect;
import org.springframework.stereotype.Component;

import java.util.Collection;

@Aspect
@Component
public class ExportLimitAspect {

    @Around("@annotation(maxExportRows)")
    public Object checkExportLimit(ProceedingJoinPoint joinPoint, MaxExportRows maxExportRows) throws Throwable {
        Object result = joinPoint.proceed();
        
        int maxRows = maxExportRows.value();
        String message = maxExportRows.message();
        
        if (result instanceof Collection) {
            Collection<?> collection = (Collection<?>) result;
            if (collection.size() > maxRows) {
                throw new ServiceException(message + "，最大允许导出" + maxRows + "条数据");
            }
        }
        
        return result;
    }
}
