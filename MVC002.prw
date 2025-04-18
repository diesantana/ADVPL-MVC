#Include "Totvs.ch"
#Include "fwmvcdef.ch"

/*/{Protheus.doc} MVC002
	Cria��o de uma aplica��o MVC Modelo 3, 
	onde temos um relacionamento entre a 
	tabela pai �lbuns e as respectivas m�sicas.
	@type user function
	@author Diego Santana
	@since 16/04/2025
/*/
User Function MVC002()
	Private aRotina := menuDef()
	Private oBrowse := fwMBrowse():new()

	oBrowse:setAlias("ZZB") // ZZB = �lbuns
	oBrowse:setDescription("�lbuns")
	oBrowse:setExecuteDef(4)
	oBrowse:addLegend("ZZB_TIPO == '1' ", "GREEN", "CD")
	oBrowse:addLegend("ZZB_TIPO == '2' ", "BLUE", "DVD")
	oBrowse:activate()
Return 

Static Function menuDef()
	Local aRotina := FWMVCMenu("MVC002")
Return aRotina

Static Function modelDef()
	Local oStruZZB := FWFormStruct( 1, "ZZB" )
	Local oStruZZA := FWFormStruct( 1, "ZZA" )
	Local oModel 
	
	oModel := MPFormModel():New( "ALBUNS_MVC" )
	oModel:AddFields( "ZZBMASTER", /*cOwner*/, oStruZZB )
	oModel:AddGrid( "ZZADETAIL", "ZZBMASTER", oStruZZA )
	
	oModel:SetRelation( "ZZADETAIL", ;
		{ { "ZZA_FILIAL", "xFilial( 'ZZA' )" }, { "ZZA_CODALB", "ZZB_COD" } }, ZZA->( IndexKey( 1 ) ) )
	oModel:setPrimaryKey({"ZZB_FILIAL", "ZZB_COD"})

	oModel:SetDescription( "Modelo de �lbuns" )
	oModel:GetModel( "ZZBMASTER" ):SetDescription( "Dados do �lbum" )
	oModel:GetModel( "ZZADETAIL" ):SetDescription( "Dados das m�sicas" )
Return oModel

Static Function viewDef()
	Local oStruZZB := FWFormStruct( 2, "ZZB" )
	Local oStruZZA := FWFormStruct( 2, "ZZA" )
	Local oModel := fwLoadModel("MVC002")
	Local oView := fwFormView():new()

	oView:setModel(oModel)
	oView:addField("VIEW_ZZB", oStruZZB, "ZZBMASTER")
	oView:addGrid("VIEW_ZZA", oStruZZA, "ZZADETAIL")
	oView:CreateHorizontalBox( 'SUPERIOR', 40 )
	oView:CreateHorizontalBox( 'INFERIOR', 60 )
	oView:SetOwnerView( 'VIEW_ZZB', 'SUPERIOR' )
	oView:SetOwnerView( 'VIEW_ZZA', 'INFERIOR' )

	oView:EnableTitleView("VIEW_ZZB", "Dados do �lbum")
	oView:EnableTitleView("VIEW_ZZA", "Dados das M�sicas")

Return oView

