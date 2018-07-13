use Transport
go

create procedure PR_Insert_Package
@districtFrom int,
@districtTo int,
@username varchar(100),
@type int,
@weight decimal(10,3)
as begin

	begin transaction [Tran1]
	begin try
		
		update MyUser set SentPackages = SentPackages + 1 where Username = @username

		insert into Package(DistrictFrom, DistrictTo, Weight, Status,IdPackageInfo) values(@districtFrom,@districtTo,@weight, 0, @type)

	commit transaction [Tran1]
	end try
	begin catch
		rollback transaction [Tran1]
		return -1
	end catch

	return SCOPE_IDENTITY() 

end

go