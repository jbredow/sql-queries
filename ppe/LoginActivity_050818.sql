SELECT WebUser.WebUserKey,
	WebUser.Username,
	Person.FullName,
	Person.Email,
	WebUser.Active,
	SRH.ViewedUserName RepInitial,
	ISNULL(AuditLog.Logins,0) Logins,
	WRG.WebRoleGroupName
	

FROM PPE_PRD.dbo.WebUser WebUser
	INNER JOIN PPE_PRD.dbo.ODSPerson Person
		ON (Person.ODSPersonKey = WebUser.ODSPersonKey)
	LEFT JOIN (SELECT AuditLog.WebUserKey,
		AuditLog.AuditAction,
		AuditLog.AuditActor UserName,      
		Count (AuditLog.CreationDate) Logins,
		Max (AuditLog.CreationDate) Last_Log

		FROM PPE_PRD.dbo.vwAuditLog AuditLog

		WHERE AuditLog.AuditAction = 'Login'
		AND AuditLog.CreationDate >= getdate () - 90

		GROUP BY AuditLog.WebUserKey,
		AuditLog.AuditAction,
		AuditLog.AuditActor) AuditLog

		ON (AuditLog.WebUserKey = WebUser.WebUserKey)

		INNER JOIN PPE_PRD.dbo.WebRoleGroup WRG
			ON (WRG.WebRoleGroupKey = WebUser.WebRoleGroupKey)

		INNER JOIN PPE_PRD.dbo.vwSalesRepHierarchy SRH
			ON (SRH.ViewerUserName = WebUser.UserName)

WHERE WRG.WebRoleGroupName LIKE ('%(SA)%') 
	AND WRG.WebRoleGroupName NOT IN ('SPC Entry (SA)','DC Entry (SA)')
	AND Webuser.Username NOT IN ('%biduser%')
	--AND Person.Email NOT IN ('brian.shook@ferguson.com')
	--AND Webuser.UserName = '1300-DB'

ORDER BY AuditLog.Logins DESC,
	Person.FullName;
