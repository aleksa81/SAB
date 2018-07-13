use Transport
go
create trigger TR_TransportOffer_Accept
on AcceptedOffer for insert, update
as begin

	declare @i cursor
	declare @idOffer int
	declare @idPackage int
	declare @username varchar(100)
	declare @districtTo int
	declare @districtFrom int
	declare @weight decimal(10,3)
	declare @idInfo int 
	declare @percentage decimal(10,3)

	-- promenljive za racunanje cene
	declare @initPrice decimal(10,3)
	declare @weightFactor decimal(10,3)
	declare @price decimal(10,3)
	declare @xTo int
	declare @yTo int
	declare @xFrom int
	declare @yFrom int
	declare @distance decimal(10,3)
	declare @finalPrice decimal (10,3)

	set @i = cursor for select IdOffer from inserted

	open @i

	fetch from @i into @idOffer

	while @@FETCH_STATUS=0
	begin
		select @idPackage = IdPackage, @username = Username, @percentage = Percentage from Offer where IdOffer = @idOffer

		-- ako kurir ne vozi 
		if (select Status from Courier where Username = @username) = 0 
		begin
			-- brisanje ostalih offera 
			delete from Offer where IdPackage = @idPackage and NOT IdOffer = @idOffer

			-- azuriranje paketa (cena i status)
			declare @kursor cursor
			set @kursor = cursor for select DistrictTo, DistrictFrom, Weight, IdPackageInfo from Package where IdPackage = @idPackage
			open @kursor
			fetch next from @kursor into @districtTo, @districtFrom, @weight, @idInfo 

			select @initPrice = InitialPrice, @weightFactor = WeightFactor, @price = Price from PackageInfo where IdPackageInfo = @idInfo
			select @xFrom = X, @yFrom = Y from District where IdDistrict = @districtFrom
			select @xTo = X, @yTo = Y from District where IdDistrict = @districtTo
			select @distance = SQRT(POWER(@xTo - @xFrom,2) + POWER(@yTo - @yFrom,2))
			select @finalPrice = (@initPrice +(@weightFactor*@weight)*@price)*@distance

			update Package set Price = @finalPrice + @finalPrice*@percentage/100, Status = 1 where IdPackage = @idPackage

			close @kursor
			deallocate @kursor

		end
		else delete from AcceptedOffer where IdOffer = @idOffer

		fetch from @i into @idOffer
	end

	close @i
	deallocate @i

end