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
	// Cria as estruturas a serem usadas no Modelo de Dados
	Local oStruZA1 := FWFormStruct( 1, 'ZA1' )
	Local oStruZA2 := FWFormStruct( 1, 'ZA2' )
	Local oModel 
	
	// Cria o objeto do Modelo de Dados
	oModel := MPFormModel():New( 'COMP021M' )
	
	// Adiciona ao modelo um componente de formulário
	oModel:AddFields( 'ZA1MASTER', /*cOwner*/, oStruZA1 )
	
	// Adiciona ao modelo uma componente de grid
	oModel:AddGrid( 'ZA2DETAIL', 'ZA1MASTER', oStruZA2 )
	
	// Faz relacionamento entre os componentes do model
	oModel:SetRelation( 'ZA2DETAIL', { { 'ZA2_FILIAL', 'xFilial( "ZA2" )' }, { 'ZA2_MUSICA', 'ZA1_MUSICA' } }, ZA2->( IndexKey( 1 ) ) )
	
	// Adiciona a descrição do Modelo de Dados
	oModel:SetDescription( 'Modelo de Musicas' )
	
	// Adiciona a descrição dos Componentes do Modelo de Dados
	oModel:GetModel( 'ZA1MASTER' ):SetDescription( 'Dados da Musica' )
	oModel:GetModel( 'ZA2DETAIL' ):SetDescription( 'Dados do Autor Da Musica' )
	
// Retorna o Modelo de dados
Return oModel
