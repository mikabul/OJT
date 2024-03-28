<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form" %>
<c:set var="root" value="${pageContext.request.contextPath}/" />
<!DOCTYPE html>
<html>
<c:forEach var="item" items="${memberList}">
	<tr>
		<td><input type="checkbox" class="checkPM"/></td>
		<td>${item.mem_seq}</td>
		<td>${item.mem_nm }</td>
		<td>${item.dept }</td>
		<td>${item.position }</td>
		<td><input type="date" min="${startDate}" max="${endDate}"/></td>
		<td><input type="date" min="${startDate}" max="${endDate}"/></td>
		<td>
			<select name="role">
				<c:forEach var="item" items="${roleList}">
					<option value="${item.dtl_cd}" class="text-left">${item.dtl_cd_nm}</option>
				</c:forEach>
			</select>
		</td>
	</tr>
</c:forEach>
</html>