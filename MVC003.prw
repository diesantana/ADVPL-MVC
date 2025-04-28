#Include "Totvs.ch"
#Include "fwmvcdef.ch"

/*/{Protheus.doc} MVC003
	Fonte usado para aprender validações
	em telas MVC
	@type user function
	@author Diego Santana
	@since 21/04/2025
/*/
User Function MVC003()
	Private aRotina := menuDef()
	Private oBrowse := fwMBrowse():new()

	oBrowse:setAlias("ZZB") // ZZB = Álbuns
	oBrowse:setDescription("Álbuns")
	oBrowse:setExecuteDef(4)
	oBrowse:addLegend("ZZB_TIPO == '1' ", "GREEN", "CD")
	oBrowse:addLegend("ZZB_TIPO == '2' ", "BLUE", "DVD")
	oBrowse:activate()
Return 

Static Function menuDef()
	Local aRotina := FWMVCMenu("MVC003")
Return aRotina

Static Function modelDef()
	Local oStruZZB := FWFormStruct( 1, "ZZB" )
	Local oStruZZA := FWFormStruct( 1, "ZZA" )
	Local oModel 
	
	oModel := MPFormModel():New( "ALBUNS_MVC" )
	oModel:AddFields( "ZZBMASTER", /*cOwner*/, oStruZZB )
	oModel:AddGrid( "ZZADETAIL", "ZZBMASTER", oStruZZA )

	// Validação na abertura do modelo
	oModel:setVldActivate({ |oModel| activateVld(oModel)})
	// Validação de linha duplicada
	oModel:GetModel( "ZZADETAIL" ):setUniqueLine({"ZZA_FILIAL", "ZZA_NOME"})
	
	oModel:SetRelation( "ZZADETAIL", ;
		{ { "ZZA_FILIAL", "xFilial( 'ZZA' )" }, { "ZZA_CODALB", "ZZB_COD" } }, ZZA->( IndexKey( 1 ) ) )
	oModel:setPrimaryKey({"ZZB_FILIAL", "ZZB_COD"})

	oModel:SetDescription( "Modelo de Álbuns (Validações)" )
	oModel:GetModel( "ZZBMASTER" ):SetDescription( "Dados do álbum" )
	oModel:GetModel( "ZZADETAIL" ):SetDescription( "Dados das músicas" )
Return oModel

Static Function viewDef()
	Local oStruZZB := FWFormStruct( 2, "ZZB" )
	Local oStruZZA := FWFormStruct( 2, "ZZA" )
	oStruZZB:RemoveField('ZZB_OK')
	oStruZZB:RemoveField('ZZB_USER')
	
	Local oModel := fwLoadModel("MVC003")
	Local oView := fwFormView():new()

	oView:setModel(oModel)
	oView:addField("VIEW_ZZB", oStruZZB, "ZZBMASTER")
	oView:addGrid("VIEW_ZZA", oStruZZA, "ZZADETAIL")

	// Define um autoincremento para o campo ZZA_NUM
	oView:AddIncrementField( "VIEW_ZZA", "ZZA_NUM" )

	oView:CreateHorizontalBox( 'SUPERIOR', 40 )
	oView:CreateHorizontalBox( 'INFERIOR', 60 )
	oView:SetOwnerView( 'VIEW_ZZB', 'SUPERIOR' )
	oView:SetOwnerView( 'VIEW_ZZA', 'INFERIOR' )

	oView:EnableTitleView("VIEW_ZZB", "Dados do Álbum")
	oView:EnableTitleView("VIEW_ZZA", "Dados das Músicas")

Return oView

/*/{Protheus.doc} activateVld
	Valida se a data base do sistema esta correta
	@type  Static Function
	@author Diego Santana
	@since 21/04/2025
/*/
Static Function activateVld(oModel)
	Local lValid := .T.

	If dDataBase != date()
		lValid := .F. //Se e data corrente for diferente da data do sistema, retorna false.

		// Exibe uma msg de erro e solução
		Help(NIL, NIL, "activateVld", NIL, "Data do sistema é diferente da data atual",;
		1, 0, NIL, NIL, NIL, NIL, NIL, {"Altere a data do sistema para prosseguir"})
	EndIf
	
Return lValid

 