
CREATE TABLE [AcceptedOffer]
( 
	[AcceptedTime]       datetime  NOT NULL ,
	[IdOffer]            integer  NOT NULL 
)
go

ALTER TABLE [AcceptedOffer]
	ADD CONSTRAINT [XPKAcceptedOffer] PRIMARY KEY  CLUSTERED ([IdOffer] ASC)
go

CREATE TABLE [Administrator]
( 
	[Username]           varchar(100)  NOT NULL 
)
go

ALTER TABLE [Administrator]
	ADD CONSTRAINT [XPKAdministrator] PRIMARY KEY  CLUSTERED ([Username] ASC)
go

CREATE TABLE [City]
( 
	[IdCity]             integer  NOT NULL  IDENTITY ,
	[Name]               varchar(100)  NOT NULL ,
	[PostalCode]         varchar(100)  NOT NULL 
)
go

ALTER TABLE [City]
	ADD CONSTRAINT [XPKCity] PRIMARY KEY  CLUSTERED ([IdCity] ASC)
go

ALTER TABLE [City]
	ADD CONSTRAINT [XAK2Postal_Code] UNIQUE ([PostalCode]  ASC)
go

ALTER TABLE [City]
	ADD CONSTRAINT [XAKCity_Name] UNIQUE ([Name]  ASC)
go

CREATE TABLE [Courier]
( 
	[DeliveredPackages]  integer  NOT NULL ,
	[Profit]             decimal(10,3)  NOT NULL ,
	[Status]             Integer  NOT NULL 
	CONSTRAINT [DriveConstraint_625150726]
		CHECK  ( [Status]=0 OR [Status]=1 ),
	[Username]           varchar(100)  NOT NULL 
)
go

ALTER TABLE [Courier]
	ADD CONSTRAINT [XPKCourier] PRIMARY KEY  CLUSTERED ([Username] ASC)
go

CREATE TABLE [District]
( 
	[IdDistrict]         integer  NOT NULL  IDENTITY ,
	[X]                  integer  NOT NULL ,
	[Y]                  integer  NOT NULL ,
	[IdCity]             integer  NOT NULL ,
	[Name]               Varchar(100)  NULL 
)
go

ALTER TABLE [District]
	ADD CONSTRAINT [XPKDistrict] PRIMARY KEY  CLUSTERED ([IdDistrict] ASC)
go

ALTER TABLE [District]
	ADD CONSTRAINT [XAKDistrict_Name] UNIQUE ([IdCity]  ASC,[Name]  ASC)
go

ALTER TABLE [District]
	ADD CONSTRAINT [XAKDistrict_XY] UNIQUE ([X]  ASC,[Y]  ASC)
go

CREATE TABLE [Drives]
( 
	[LicenceNumber]      varchar(100)  NOT NULL ,
	[Username]           varchar(100)  NOT NULL 
)
go

ALTER TABLE [Drives]
	ADD CONSTRAINT [XPKDrives] PRIMARY KEY  CLUSTERED ([Username] ASC)
go

ALTER TABLE [Drives]
	ADD CONSTRAINT [XAKLicenceNumber] UNIQUE ([LicenceNumber]  ASC)
go

CREATE TABLE [Fuel]
( 
	[IdFuel]             integer  NOT NULL 
	CONSTRAINT [FuelConstraint_714021037]
		CHECK  ( [IdFuel]=0 OR [IdFuel]=1 OR [IdFuel]=2 ),
	[Price]              decimal(10,3)  NOT NULL 
)
go

ALTER TABLE [Fuel]
	ADD CONSTRAINT [XPKFuel] PRIMARY KEY  CLUSTERED ([IdFuel] ASC)
go

CREATE TABLE [MyUser]
( 
	[Name]               varchar(100)  NOT NULL ,
	[Surname]            varchar(100)  NOT NULL ,
	[Password]           varchar(100)  NOT NULL ,
	[SentPackages]       integer  NOT NULL ,
	[Username]           varchar(100)  NOT NULL 
)
go

ALTER TABLE [MyUser]
	ADD CONSTRAINT [XPKUser] PRIMARY KEY  CLUSTERED ([Username] ASC)
go

CREATE TABLE [Offer]
( 
	[IdPackage]          integer  NOT NULL ,
	[Percentage]         decimal(10,3)  NOT NULL 
	CONSTRAINT [PercentageConstraint_966561978]
		CHECK  ( Percentage BETWEEN 0 AND 100 ),
	[Username]           varchar(100)  NOT NULL ,
	[IdOffer]            integer  NOT NULL  IDENTITY 
)
go

ALTER TABLE [Offer]
	ADD CONSTRAINT [XPKOffer] PRIMARY KEY  CLUSTERED ([IdOffer] ASC)
go

CREATE TABLE [Package]
( 
	[IdPackage]          integer  NOT NULL  IDENTITY ,
	[DistrictTo]         integer  NOT NULL ,
	[DistrictFrom]       integer  NOT NULL ,
	[Weight]             decimal(10,3)  NOT NULL ,
	[Status]             integer  NOT NULL 
	CONSTRAINT [PackageStatusConstraint_1650422329]
		CHECK  ( [Status]=0 OR [Status]=1 OR [Status]=2 OR [Status]=3 ),
	[Price]              decimal(10,3)  NULL ,
	[IdPackageInfo]      integer  NOT NULL 
)
go

ALTER TABLE [Package]
	ADD CONSTRAINT [XPKPackage] PRIMARY KEY  CLUSTERED ([IdPackage] ASC)
go

CREATE TABLE [PackageInfo]
( 
	[IdPackageInfo]      integer  NOT NULL 
	CONSTRAINT [PackageTypeConstraint_1483873466]
		CHECK  ( [IdPackageInfo]=0 OR [IdPackageInfo]=1 OR [IdPackageInfo]=2 ),
	[InitialPrice]       decimal(10,3)  NOT NULL ,
	[WeightFactor]       decimal(10,3)  NOT NULL ,
	[Price]              decimal(10,3)  NOT NULL 
)
go

ALTER TABLE [PackageInfo]
	ADD CONSTRAINT [XPKPackageInfo] PRIMARY KEY  CLUSTERED ([IdPackageInfo] ASC)
go

CREATE TABLE [Request]
( 
	[LicenceNumber]      varchar(100)  NOT NULL ,
	[Username]           varchar(100)  NOT NULL 
)
go

ALTER TABLE [Request]
	ADD CONSTRAINT [XPKRequest] PRIMARY KEY  CLUSTERED ([Username] ASC)
go

CREATE TABLE [Vehicle]
( 
	[LicenceNumber]      varchar(100)  NOT NULL ,
	[FuelEfficiency]     decimal(10,3)  NOT NULL ,
	[IdFuel]             integer  NOT NULL 
)
go

ALTER TABLE [Vehicle]
	ADD CONSTRAINT [XPKVehicle] PRIMARY KEY  CLUSTERED ([LicenceNumber] ASC)
go


ALTER TABLE [AcceptedOffer]
	ADD CONSTRAINT [R_19] FOREIGN KEY ([IdOffer]) REFERENCES [Offer]([IdOffer])
		ON DELETE CASCADE
		ON UPDATE CASCADE
go


ALTER TABLE [Administrator]
	ADD CONSTRAINT [R_3] FOREIGN KEY ([Username]) REFERENCES [MyUser]([Username])
		ON DELETE CASCADE
		ON UPDATE CASCADE
go


ALTER TABLE [Courier]
	ADD CONSTRAINT [R_4] FOREIGN KEY ([Username]) REFERENCES [MyUser]([Username])
		ON DELETE NO ACTION
		ON UPDATE CASCADE
go


ALTER TABLE [District]
	ADD CONSTRAINT [R_2] FOREIGN KEY ([IdCity]) REFERENCES [City]([IdCity])
		ON DELETE NO ACTION
		ON UPDATE CASCADE
go


ALTER TABLE [Drives]
	ADD CONSTRAINT [R_8] FOREIGN KEY ([LicenceNumber]) REFERENCES [Vehicle]([LicenceNumber])
		ON DELETE CASCADE
		ON UPDATE CASCADE
go

ALTER TABLE [Drives]
	ADD CONSTRAINT [R_7] FOREIGN KEY ([Username]) REFERENCES [Courier]([Username])
		ON DELETE CASCADE
		ON UPDATE CASCADE
go


ALTER TABLE [Offer]
	ADD CONSTRAINT [R_14] FOREIGN KEY ([IdPackage]) REFERENCES [Package]([IdPackage])
		ON DELETE CASCADE
		ON UPDATE CASCADE
go

ALTER TABLE [Offer]
	ADD CONSTRAINT [R_15] FOREIGN KEY ([Username]) REFERENCES [Courier]([Username])
		ON DELETE CASCADE
		ON UPDATE CASCADE
go


ALTER TABLE [Package]
	ADD CONSTRAINT [R_9] FOREIGN KEY ([DistrictTo]) REFERENCES [District]([IdDistrict])
		ON DELETE NO ACTION
		ON UPDATE NO ACTION
go

ALTER TABLE [Package]
	ADD CONSTRAINT [R_10] FOREIGN KEY ([DistrictFrom]) REFERENCES [District]([IdDistrict])
		ON DELETE NO ACTION
		ON UPDATE NO ACTION
go

ALTER TABLE [Package]
	ADD CONSTRAINT [R_17] FOREIGN KEY ([IdPackageInfo]) REFERENCES [PackageInfo]([IdPackageInfo])
go


ALTER TABLE [Request]
	ADD CONSTRAINT [R_5] FOREIGN KEY ([Username]) REFERENCES [MyUser]([Username])
		ON DELETE NO ACTION
		ON UPDATE CASCADE
go

ALTER TABLE [Request]
	ADD CONSTRAINT [R_6] FOREIGN KEY ([LicenceNumber]) REFERENCES [Vehicle]([LicenceNumber])
		ON DELETE NO ACTION
		ON UPDATE CASCADE
go


ALTER TABLE [Vehicle]
	ADD CONSTRAINT [R_16] FOREIGN KEY ([IdFuel]) REFERENCES [Fuel]([IdFuel])
go


CREATE TRIGGER tD_City ON City FOR DELETE AS
/* erwin Builtin Trigger */
/* DELETE trigger on City */
BEGIN
  DECLARE  @errno   int,
           @severity int,
           @state    int,
           @errmsg  varchar(255)
    /* erwin Builtin Trigger */
    /* City  District on parent delete no action */
    /* ERWIN_RELATION:CHECKSUM="000103b2", PARENT_OWNER="", PARENT_TABLE="City"
    CHILD_OWNER="", CHILD_TABLE="District"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_2", FK_COLUMNS="IdCity" */
    IF EXISTS (
      SELECT * FROM deleted,District
      WHERE
        /*  %JoinFKPK(District,deleted," = "," AND") */
        District.IdCity = deleted.IdCity
    )
    BEGIN
      SELECT @errno  = 30001,
             @errmsg = 'Cannot delete City because District exists.'
      GOTO error
    END


    /* erwin Builtin Trigger */
    RETURN
error:
   RAISERROR (@errmsg, -- Message text.
              @severity, -- Severity (0~25).
              @state) -- State (0~255).
    rollback transaction
END

go


CREATE TRIGGER tU_City ON City FOR UPDATE AS
/* erwin Builtin Trigger */
/* UPDATE trigger on City */
BEGIN
  DECLARE  @numrows int,
           @nullcnt int,
           @validcnt int,
           @insIdCity integer,
           @errno   int,
           @severity int,
           @state    int,
           @errmsg  varchar(255)

  SELECT @numrows = @@rowcount
  /* erwin Builtin Trigger */
  /* City  District on parent update cascade */
  /* ERWIN_RELATION:CHECKSUM="00016d83", PARENT_OWNER="", PARENT_TABLE="City"
    CHILD_OWNER="", CHILD_TABLE="District"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_2", FK_COLUMNS="IdCity" */
  IF
    /* %ParentPK(" OR",UPDATE) */
    UPDATE(IdCity)
  BEGIN
    IF @numrows = 1
    BEGIN
      SELECT @insIdCity = inserted.IdCity
        FROM inserted
      UPDATE District
      SET
        /*  %JoinFKPK(District,@ins," = ",",") */
        District.IdCity = @insIdCity
      FROM District,inserted,deleted
      WHERE
        /*  %JoinFKPK(District,deleted," = "," AND") */
        District.IdCity = deleted.IdCity
    END
    ELSE
    BEGIN
      SELECT @errno = 30006,
             @errmsg = 'Cannot cascade City update because more than one row has been affected.'
      GOTO error
    END
  END


  /* erwin Builtin Trigger */
  RETURN
error:
   RAISERROR (@errmsg, -- Message text.
              @severity, -- Severity (0~25).
              @state) -- State (0~255).
    rollback transaction
END

go




CREATE TRIGGER tD_Courier ON Courier FOR DELETE AS
/* erwin Builtin Trigger */
/* DELETE trigger on Courier */
BEGIN
  DECLARE  @errno   int,
           @severity int,
           @state    int,
           @errmsg  varchar(255)
    /* erwin Builtin Trigger */
    /* Courier  Offer on parent delete cascade */
    /* ERWIN_RELATION:CHECKSUM="00018741", PARENT_OWNER="", PARENT_TABLE="Courier"
    CHILD_OWNER="", CHILD_TABLE="Offer"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_15", FK_COLUMNS="Username" */
    DELETE Offer
      FROM Offer,deleted
      WHERE
        /*  %JoinFKPK(Offer,deleted," = "," AND") */
        Offer.Username = deleted.Username

    /* erwin Builtin Trigger */
    /* Courier  Drives on parent delete cascade */
    /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="Courier"
    CHILD_OWNER="", CHILD_TABLE="Drives"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_7", FK_COLUMNS="Username" */
    DELETE Drives
      FROM Drives,deleted
      WHERE
        /*  %JoinFKPK(Drives,deleted," = "," AND") */
        Drives.Username = deleted.Username


    /* erwin Builtin Trigger */
    RETURN
error:
   RAISERROR (@errmsg, -- Message text.
              @severity, -- Severity (0~25).
              @state) -- State (0~255).
    rollback transaction
END

go


CREATE TRIGGER tU_Courier ON Courier FOR UPDATE AS
/* erwin Builtin Trigger */
/* UPDATE trigger on Courier */
BEGIN
  DECLARE  @numrows int,
           @nullcnt int,
           @validcnt int,
           @insUsername varchar(100),
           @errno   int,
           @severity int,
           @state    int,
           @errmsg  varchar(255)

  SELECT @numrows = @@rowcount
  /* erwin Builtin Trigger */
  /* Courier  Offer on parent update cascade */
  /* ERWIN_RELATION:CHECKSUM="0002b4c9", PARENT_OWNER="", PARENT_TABLE="Courier"
    CHILD_OWNER="", CHILD_TABLE="Offer"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_15", FK_COLUMNS="Username" */
  IF
    /* %ParentPK(" OR",UPDATE) */
    UPDATE(Username)
  BEGIN
    IF @numrows = 1
    BEGIN
      SELECT @insUsername = inserted.Username
        FROM inserted
      UPDATE Offer
      SET
        /*  %JoinFKPK(Offer,@ins," = ",",") */
        Offer.Username = @insUsername
      FROM Offer,inserted,deleted
      WHERE
        /*  %JoinFKPK(Offer,deleted," = "," AND") */
        Offer.Username = deleted.Username
    END
    ELSE
    BEGIN
      SELECT @errno = 30006,
             @errmsg = 'Cannot cascade Courier update because more than one row has been affected.'
      GOTO error
    END
  END

  /* erwin Builtin Trigger */
  /* Courier  Drives on parent update cascade */
  /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="Courier"
    CHILD_OWNER="", CHILD_TABLE="Drives"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_7", FK_COLUMNS="Username" */
  IF
    /* %ParentPK(" OR",UPDATE) */
    UPDATE(Username)
  BEGIN
    IF @numrows = 1
    BEGIN
      SELECT @insUsername = inserted.Username
        FROM inserted
      UPDATE Drives
      SET
        /*  %JoinFKPK(Drives,@ins," = ",",") */
        Drives.Username = @insUsername
      FROM Drives,inserted,deleted
      WHERE
        /*  %JoinFKPK(Drives,deleted," = "," AND") */
        Drives.Username = deleted.Username
    END
    ELSE
    BEGIN
      SELECT @errno = 30006,
             @errmsg = 'Cannot cascade Courier update because more than one row has been affected.'
      GOTO error
    END
  END


  /* erwin Builtin Trigger */
  RETURN
error:
   RAISERROR (@errmsg, -- Message text.
              @severity, -- Severity (0~25).
              @state) -- State (0~255).
    rollback transaction
END

go




CREATE TRIGGER tD_District ON District FOR DELETE AS
/* erwin Builtin Trigger */
/* DELETE trigger on District */
BEGIN
  DECLARE  @errno   int,
           @severity int,
           @state    int,
           @errmsg  varchar(255)
    /* erwin Builtin Trigger */
    /* District  Package on parent delete no action */
    /* ERWIN_RELATION:CHECKSUM="0001f622", PARENT_OWNER="", PARENT_TABLE="District"
    CHILD_OWNER="", CHILD_TABLE="Package"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_10", FK_COLUMNS="DistrictFrom" */
    IF EXISTS (
      SELECT * FROM deleted,Package
      WHERE
        /*  %JoinFKPK(Package,deleted," = "," AND") */
        Package.DistrictFrom = deleted.IdDistrict
    )
    BEGIN
      SELECT @errno  = 30001,
             @errmsg = 'Cannot delete District because Package exists.'
      GOTO error
    END

    /* erwin Builtin Trigger */
    /* District DistrictFrom Package on parent delete no action */
    /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="District"
    CHILD_OWNER="", CHILD_TABLE="Package"
    P2C_VERB_PHRASE="DistrictFrom", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_9", FK_COLUMNS="DistrictTo" */
    IF EXISTS (
      SELECT * FROM deleted,Package
      WHERE
        /*  %JoinFKPK(Package,deleted," = "," AND") */
        Package.DistrictTo = deleted.IdDistrict
    )
    BEGIN
      SELECT @errno  = 30001,
             @errmsg = 'Cannot delete District because Package exists.'
      GOTO error
    END


    /* erwin Builtin Trigger */
    RETURN
error:
   RAISERROR (@errmsg, -- Message text.
              @severity, -- Severity (0~25).
              @state) -- State (0~255).
    rollback transaction
END

go


CREATE TRIGGER tU_District ON District FOR UPDATE AS
/* erwin Builtin Trigger */
/* UPDATE trigger on District */
BEGIN
  DECLARE  @numrows int,
           @nullcnt int,
           @validcnt int,
           @insIdDistrict integer,
           @errno   int,
           @severity int,
           @state    int,
           @errmsg  varchar(255)

  SELECT @numrows = @@rowcount
  /* erwin Builtin Trigger */
  /* District  Package on parent update no action */
  /* ERWIN_RELATION:CHECKSUM="00022db3", PARENT_OWNER="", PARENT_TABLE="District"
    CHILD_OWNER="", CHILD_TABLE="Package"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_10", FK_COLUMNS="DistrictFrom" */
  IF
    /* %ParentPK(" OR",UPDATE) */
    UPDATE(IdDistrict)
  BEGIN
    IF EXISTS (
      SELECT * FROM deleted,Package
      WHERE
        /*  %JoinFKPK(Package,deleted," = "," AND") */
        Package.DistrictFrom = deleted.IdDistrict
    )
    BEGIN
      SELECT @errno  = 30005,
             @errmsg = 'Cannot update District because Package exists.'
      GOTO error
    END
  END

  /* erwin Builtin Trigger */
  /* District DistrictFrom Package on parent update no action */
  /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="District"
    CHILD_OWNER="", CHILD_TABLE="Package"
    P2C_VERB_PHRASE="DistrictFrom", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_9", FK_COLUMNS="DistrictTo" */
  IF
    /* %ParentPK(" OR",UPDATE) */
    UPDATE(IdDistrict)
  BEGIN
    IF EXISTS (
      SELECT * FROM deleted,Package
      WHERE
        /*  %JoinFKPK(Package,deleted," = "," AND") */
        Package.DistrictTo = deleted.IdDistrict
    )
    BEGIN
      SELECT @errno  = 30005,
             @errmsg = 'Cannot update District because Package exists.'
      GOTO error
    END
  END


  /* erwin Builtin Trigger */
  RETURN
error:
   RAISERROR (@errmsg, -- Message text.
              @severity, -- Severity (0~25).
              @state) -- State (0~255).
    rollback transaction
END

go




CREATE TRIGGER tD_MyUser ON MyUser FOR DELETE AS
/* erwin Builtin Trigger */
/* DELETE trigger on MyUser */
BEGIN
  DECLARE  @errno   int,
           @severity int,
           @state    int,
           @errmsg  varchar(255)
    /* erwin Builtin Trigger */
    /* MyUser  Request on parent delete no action */
    /* ERWIN_RELATION:CHECKSUM="00029511", PARENT_OWNER="", PARENT_TABLE="MyUser"
    CHILD_OWNER="", CHILD_TABLE="Request"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_5", FK_COLUMNS="Username" */
    IF EXISTS (
      SELECT * FROM deleted,Request
      WHERE
        /*  %JoinFKPK(Request,deleted," = "," AND") */
        Request.Username = deleted.Username
    )
    BEGIN
      SELECT @errno  = 30001,
             @errmsg = 'Cannot delete MyUser because Request exists.'
      GOTO error
    END

    /* erwin Builtin Trigger */
    /* MyUser  Courier on parent delete no action */
    /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="MyUser"
    CHILD_OWNER="", CHILD_TABLE="Courier"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_4", FK_COLUMNS="Username" */
    IF EXISTS (
      SELECT * FROM deleted,Courier
      WHERE
        /*  %JoinFKPK(Courier,deleted," = "," AND") */
        Courier.Username = deleted.Username
    )
    BEGIN
      SELECT @errno  = 30001,
             @errmsg = 'Cannot delete MyUser because Courier exists.'
      GOTO error
    END

    /* erwin Builtin Trigger */
    /* MyUser  Administrator on parent delete cascade */
    /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="MyUser"
    CHILD_OWNER="", CHILD_TABLE="Administrator"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_3", FK_COLUMNS="Username" */
    DELETE Administrator
      FROM Administrator,deleted
      WHERE
        /*  %JoinFKPK(Administrator,deleted," = "," AND") */
        Administrator.Username = deleted.Username


    /* erwin Builtin Trigger */
    RETURN
error:
   RAISERROR (@errmsg, -- Message text.
              @severity, -- Severity (0~25).
              @state) -- State (0~255).
    rollback transaction
END

go


CREATE TRIGGER tU_MyUser ON MyUser FOR UPDATE AS
/* erwin Builtin Trigger */
/* UPDATE trigger on MyUser */
BEGIN
  DECLARE  @numrows int,
           @nullcnt int,
           @validcnt int,
           @insUsername varchar(100),
           @errno   int,
           @severity int,
           @state    int,
           @errmsg  varchar(255)

  SELECT @numrows = @@rowcount
  /* erwin Builtin Trigger */
  /* MyUser  Request on parent update cascade */
  /* ERWIN_RELATION:CHECKSUM="0004114e", PARENT_OWNER="", PARENT_TABLE="MyUser"
    CHILD_OWNER="", CHILD_TABLE="Request"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_5", FK_COLUMNS="Username" */
  IF
    /* %ParentPK(" OR",UPDATE) */
    UPDATE(Username)
  BEGIN
    IF @numrows = 1
    BEGIN
      SELECT @insUsername = inserted.Username
        FROM inserted
      UPDATE Request
      SET
        /*  %JoinFKPK(Request,@ins," = ",",") */
        Request.Username = @insUsername
      FROM Request,inserted,deleted
      WHERE
        /*  %JoinFKPK(Request,deleted," = "," AND") */
        Request.Username = deleted.Username
    END
    ELSE
    BEGIN
      SELECT @errno = 30006,
             @errmsg = 'Cannot cascade MyUser update because more than one row has been affected.'
      GOTO error
    END
  END

  /* erwin Builtin Trigger */
  /* MyUser  Courier on parent update cascade */
  /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="MyUser"
    CHILD_OWNER="", CHILD_TABLE="Courier"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_4", FK_COLUMNS="Username" */
  IF
    /* %ParentPK(" OR",UPDATE) */
    UPDATE(Username)
  BEGIN
    IF @numrows = 1
    BEGIN
      SELECT @insUsername = inserted.Username
        FROM inserted
      UPDATE Courier
      SET
        /*  %JoinFKPK(Courier,@ins," = ",",") */
        Courier.Username = @insUsername
      FROM Courier,inserted,deleted
      WHERE
        /*  %JoinFKPK(Courier,deleted," = "," AND") */
        Courier.Username = deleted.Username
    END
    ELSE
    BEGIN
      SELECT @errno = 30006,
             @errmsg = 'Cannot cascade MyUser update because more than one row has been affected.'
      GOTO error
    END
  END

  /* erwin Builtin Trigger */
  /* MyUser  Administrator on parent update cascade */
  /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="MyUser"
    CHILD_OWNER="", CHILD_TABLE="Administrator"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_3", FK_COLUMNS="Username" */
  IF
    /* %ParentPK(" OR",UPDATE) */
    UPDATE(Username)
  BEGIN
    IF @numrows = 1
    BEGIN
      SELECT @insUsername = inserted.Username
        FROM inserted
      UPDATE Administrator
      SET
        /*  %JoinFKPK(Administrator,@ins," = ",",") */
        Administrator.Username = @insUsername
      FROM Administrator,inserted,deleted
      WHERE
        /*  %JoinFKPK(Administrator,deleted," = "," AND") */
        Administrator.Username = deleted.Username
    END
    ELSE
    BEGIN
      SELECT @errno = 30006,
             @errmsg = 'Cannot cascade MyUser update because more than one row has been affected.'
      GOTO error
    END
  END


  /* erwin Builtin Trigger */
  RETURN
error:
   RAISERROR (@errmsg, -- Message text.
              @severity, -- Severity (0~25).
              @state) -- State (0~255).
    rollback transaction
END

go




CREATE TRIGGER tD_Offer ON Offer FOR DELETE AS
/* erwin Builtin Trigger */
/* DELETE trigger on Offer */
BEGIN
  DECLARE  @errno   int,
           @severity int,
           @state    int,
           @errmsg  varchar(255)
    /* erwin Builtin Trigger */
    /* Offer  AcceptedOffer on parent delete cascade */
    /* ERWIN_RELATION:CHECKSUM="0000e527", PARENT_OWNER="", PARENT_TABLE="Offer"
    CHILD_OWNER="", CHILD_TABLE="AcceptedOffer"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_19", FK_COLUMNS="IdOffer" */
    DELETE AcceptedOffer
      FROM AcceptedOffer,deleted
      WHERE
        /*  %JoinFKPK(AcceptedOffer,deleted," = "," AND") */
        AcceptedOffer.IdOffer = deleted.IdOffer


    /* erwin Builtin Trigger */
    RETURN
error:
   RAISERROR (@errmsg, -- Message text.
              @severity, -- Severity (0~25).
              @state) -- State (0~255).
    rollback transaction
END

go


CREATE TRIGGER tU_Offer ON Offer FOR UPDATE AS
/* erwin Builtin Trigger */
/* UPDATE trigger on Offer */
BEGIN
  DECLARE  @numrows int,
           @nullcnt int,
           @validcnt int,
           @insIdOffer integer,
           @errno   int,
           @severity int,
           @state    int,
           @errmsg  varchar(255)

  SELECT @numrows = @@rowcount
  /* erwin Builtin Trigger */
  /* Offer  AcceptedOffer on parent update cascade */
  /* ERWIN_RELATION:CHECKSUM="00017e0e", PARENT_OWNER="", PARENT_TABLE="Offer"
    CHILD_OWNER="", CHILD_TABLE="AcceptedOffer"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_19", FK_COLUMNS="IdOffer" */
  IF
    /* %ParentPK(" OR",UPDATE) */
    UPDATE(IdOffer)
  BEGIN
    IF @numrows = 1
    BEGIN
      SELECT @insIdOffer = inserted.IdOffer
        FROM inserted
      UPDATE AcceptedOffer
      SET
        /*  %JoinFKPK(AcceptedOffer,@ins," = ",",") */
        AcceptedOffer.IdOffer = @insIdOffer
      FROM AcceptedOffer,inserted,deleted
      WHERE
        /*  %JoinFKPK(AcceptedOffer,deleted," = "," AND") */
        AcceptedOffer.IdOffer = deleted.IdOffer
    END
    ELSE
    BEGIN
      SELECT @errno = 30006,
             @errmsg = 'Cannot cascade Offer update because more than one row has been affected.'
      GOTO error
    END
  END


  /* erwin Builtin Trigger */
  RETURN
error:
   RAISERROR (@errmsg, -- Message text.
              @severity, -- Severity (0~25).
              @state) -- State (0~255).
    rollback transaction
END

go




CREATE TRIGGER tD_Package ON Package FOR DELETE AS
/* erwin Builtin Trigger */
/* DELETE trigger on Package */
BEGIN
  DECLARE  @errno   int,
           @severity int,
           @state    int,
           @errmsg  varchar(255)
    /* erwin Builtin Trigger */
    /* Package  Offer on parent delete cascade */
    /* ERWIN_RELATION:CHECKSUM="0000db73", PARENT_OWNER="", PARENT_TABLE="Package"
    CHILD_OWNER="", CHILD_TABLE="Offer"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_14", FK_COLUMNS="IdPackage" */
    DELETE Offer
      FROM Offer,deleted
      WHERE
        /*  %JoinFKPK(Offer,deleted," = "," AND") */
        Offer.IdPackage = deleted.IdPackage


    /* erwin Builtin Trigger */
    RETURN
error:
   RAISERROR (@errmsg, -- Message text.
              @severity, -- Severity (0~25).
              @state) -- State (0~255).
    rollback transaction
END

go


CREATE TRIGGER tU_Package ON Package FOR UPDATE AS
/* erwin Builtin Trigger */
/* UPDATE trigger on Package */
BEGIN
  DECLARE  @numrows int,
           @nullcnt int,
           @validcnt int,
           @insIdPackage integer,
           @errno   int,
           @severity int,
           @state    int,
           @errmsg  varchar(255)

  SELECT @numrows = @@rowcount
  /* erwin Builtin Trigger */
  /* Package  Offer on parent update cascade */
  /* ERWIN_RELATION:CHECKSUM="0001757c", PARENT_OWNER="", PARENT_TABLE="Package"
    CHILD_OWNER="", CHILD_TABLE="Offer"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_14", FK_COLUMNS="IdPackage" */
  IF
    /* %ParentPK(" OR",UPDATE) */
    UPDATE(IdPackage)
  BEGIN
    IF @numrows = 1
    BEGIN
      SELECT @insIdPackage = inserted.IdPackage
        FROM inserted
      UPDATE Offer
      SET
        /*  %JoinFKPK(Offer,@ins," = ",",") */
        Offer.IdPackage = @insIdPackage
      FROM Offer,inserted,deleted
      WHERE
        /*  %JoinFKPK(Offer,deleted," = "," AND") */
        Offer.IdPackage = deleted.IdPackage
    END
    ELSE
    BEGIN
      SELECT @errno = 30006,
             @errmsg = 'Cannot cascade Package update because more than one row has been affected.'
      GOTO error
    END
  END


  /* erwin Builtin Trigger */
  RETURN
error:
   RAISERROR (@errmsg, -- Message text.
              @severity, -- Severity (0~25).
              @state) -- State (0~255).
    rollback transaction
END

go




CREATE TRIGGER tD_Vehicle ON Vehicle FOR DELETE AS
/* erwin Builtin Trigger */
/* DELETE trigger on Vehicle */
BEGIN
  DECLARE  @errno   int,
           @severity int,
           @state    int,
           @errmsg  varchar(255)
    /* erwin Builtin Trigger */
    /* Vehicle  Drives on parent delete cascade */
    /* ERWIN_RELATION:CHECKSUM="0001cdaa", PARENT_OWNER="", PARENT_TABLE="Vehicle"
    CHILD_OWNER="", CHILD_TABLE="Drives"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_8", FK_COLUMNS="LicenceNumber" */
    DELETE Drives
      FROM Drives,deleted
      WHERE
        /*  %JoinFKPK(Drives,deleted," = "," AND") */
        Drives.LicenceNumber = deleted.LicenceNumber

    /* erwin Builtin Trigger */
    /* Vehicle  Request on parent delete no action */
    /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="Vehicle"
    CHILD_OWNER="", CHILD_TABLE="Request"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_6", FK_COLUMNS="LicenceNumber" */
    IF EXISTS (
      SELECT * FROM deleted,Request
      WHERE
        /*  %JoinFKPK(Request,deleted," = "," AND") */
        Request.LicenceNumber = deleted.LicenceNumber
    )
    BEGIN
      SELECT @errno  = 30001,
             @errmsg = 'Cannot delete Vehicle because Request exists.'
      GOTO error
    END


    /* erwin Builtin Trigger */
    RETURN
error:
   RAISERROR (@errmsg, -- Message text.
              @severity, -- Severity (0~25).
              @state) -- State (0~255).
    rollback transaction
END

go


CREATE TRIGGER tU_Vehicle ON Vehicle FOR UPDATE AS
/* erwin Builtin Trigger */
/* UPDATE trigger on Vehicle */
BEGIN
  DECLARE  @numrows int,
           @nullcnt int,
           @validcnt int,
           @insLicenceNumber varchar(100),
           @errno   int,
           @severity int,
           @state    int,
           @errmsg  varchar(255)

  SELECT @numrows = @@rowcount
  /* erwin Builtin Trigger */
  /* Vehicle  Drives on parent update cascade */
  /* ERWIN_RELATION:CHECKSUM="0002d58f", PARENT_OWNER="", PARENT_TABLE="Vehicle"
    CHILD_OWNER="", CHILD_TABLE="Drives"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_8", FK_COLUMNS="LicenceNumber" */
  IF
    /* %ParentPK(" OR",UPDATE) */
    UPDATE(LicenceNumber)
  BEGIN
    IF @numrows = 1
    BEGIN
      SELECT @insLicenceNumber = inserted.LicenceNumber
        FROM inserted
      UPDATE Drives
      SET
        /*  %JoinFKPK(Drives,@ins," = ",",") */
        Drives.LicenceNumber = @insLicenceNumber
      FROM Drives,inserted,deleted
      WHERE
        /*  %JoinFKPK(Drives,deleted," = "," AND") */
        Drives.LicenceNumber = deleted.LicenceNumber
    END
    ELSE
    BEGIN
      SELECT @errno = 30006,
             @errmsg = 'Cannot cascade Vehicle update because more than one row has been affected.'
      GOTO error
    END
  END

  /* erwin Builtin Trigger */
  /* Vehicle  Request on parent update cascade */
  /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="Vehicle"
    CHILD_OWNER="", CHILD_TABLE="Request"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_6", FK_COLUMNS="LicenceNumber" */
  IF
    /* %ParentPK(" OR",UPDATE) */
    UPDATE(LicenceNumber)
  BEGIN
    IF @numrows = 1
    BEGIN
      SELECT @insLicenceNumber = inserted.LicenceNumber
        FROM inserted
      UPDATE Request
      SET
        /*  %JoinFKPK(Request,@ins," = ",",") */
        Request.LicenceNumber = @insLicenceNumber
      FROM Request,inserted,deleted
      WHERE
        /*  %JoinFKPK(Request,deleted," = "," AND") */
        Request.LicenceNumber = deleted.LicenceNumber
    END
    ELSE
    BEGIN
      SELECT @errno = 30006,
             @errmsg = 'Cannot cascade Vehicle update because more than one row has been affected.'
      GOTO error
    END
  END


  /* erwin Builtin Trigger */
  RETURN
error:
   RAISERROR (@errmsg, -- Message text.
              @severity, -- Severity (0~25).
              @state) -- State (0~255).
    rollback transaction
END

go

use Transport
go

create procedure PR_Grant_Request
@username varchar(100)
as begin

	declare @licencenumber varchar(100)

	-- da li postoji request?
	if not exists (select * from Request where Username = @username) return 0

	select @licencenumber = LicenceNumber from Request where Username = @username

	begin transaction [Tran1]
	begin try

		insert into Courier(Username, DeliveredPackages, Profit, Status) values (@username, 0,0,0)
	
		insert into Drives(Username, LicenceNumber) values (@username, @licencenumber)

		delete from Request where Username = @username

	commit transaction [Tran1]
	end try
	begin catch
		rollback transaction [Tran1]
		return 0
	end catch

	return 1
end

go

create procedure PR_Declare_Admin
@username varchar(100)
as begin

	declare @licencenumber varchar(100)

	-- da li postoji user?
	if not exists (select * from MyUser where Username = @username) return 2

	-- da li je vec admin?
	if exists (select * from Administrator where Username = @username) return 1

	insert into Administrator(Username) values (@username)

	return 0

end

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

create procedure PR_Insert_Offer
@courierUsername varchar(100),
@packageId int,
@percentage decimal(10,3)
as begin
	
	-- kurir ne sme biti u voznji
	if not exists(select * from Courier where Username = @courierUsername and Status = 0) return -1

	-- paket mora biti u statusu kreiran
	if exists (select * from Package where IdPackage = @packageId and Status <> 0 ) return -1

	begin transaction [Tran1]
	begin try

		insert into Offer(Username, IdPackage, Percentage) values (@courierUsername, @packageId, @percentage)

	commit transaction [Tran1]
	end try
	begin catch
		rollback transaction [Tran1]
		return -1
	end catch

	return SCOPE_IDENTITY() 

end

go
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

go


