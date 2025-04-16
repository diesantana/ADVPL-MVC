#Include "Totvs.ch"
#Include "fwmvcdef.ch"

/*/{Protheus.doc} MVC002
	Criação de uma aplicação MVC Modelo 3, 
	onde temos um relacionamento entre a 
	tabela pai Álbuns e as respectivas músicas.
	@type user function
	@author Diego Santana
	@since 16/04/2025
/*/
User Function MVC002()
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
	
	oModel:SetDescription( "Modelo de Álbuns" )
	oModel:GetModel( "ZZBMASTER" ):SetDescription( "Dados do álbum" )
	oModel:GetModel( "ZZADETAIL" ):SetDescription( "Dados das músicas" )
Return oModel

