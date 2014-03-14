<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:fn="http://www.w3.org/2005/xpath-functions" xmlns:esri="http://www.esri.com/schemas/ArcGIS/10.0"
xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
<!-- xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/-->
<xsl:output method="text" />
<xsl:strip-space elements="*"/>

<!-- Initialization section - Global settings -->
<!-- indentation per level -->
<xsl:param name="level" select="1"/>
<xsl:variable name="indent" select=" ' ' "/>
<xsl:variable name="domainIndent">
	<xsl:call-template name="dup">
		<xsl:with-param name="input" select="$indent"/>
		<xsl:with-param name="count" select="2"/>
	</xsl:call-template>
</xsl:variable>
<!-- Formatting - the column width for displaying output -->
<xsl:variable name="colWidth" select="30"/>
<!-- Common settings and outputs re-used in the various templates -->
<xsl:variable name="_newLine">
	<xsl:text>&#xa;</xsl:text><xsl:text/>
</xsl:variable>
<xsl:variable name="spacer">
	<xsl:call-template name="dup">
		<xsl:with-param name="input" select="$indent"/>
		<xsl:with-param name="count" select="$colWidth"/>
	</xsl:call-template>
</xsl:variable>
<xsl:variable name="underline">
	<xsl:call-template name="dup">
		<xsl:with-param name="input" select=" '-' "/>
		<xsl:with-param name="count" select="80"/>
	</xsl:call-template>
	<xsl:value-of select="$_newLine"/>
</xsl:variable>
<!--  END Initialization section  Global settings -->

<!-- main entry point -->
<xsl:template match="/">
	<xsl:apply-templates select="*/WorkspaceDefinition"/>
</xsl:template>

<xsl:template match="WorkspaceDefinition">
	<xsl:apply-templates select="WorkspaceType"/>
	<xsl:apply-templates select="Version"/>
	<xsl:call-template name="stats">
		<xsl:with-param name="_wsDef" select="."/>
	</xsl:call-template>
	
	<!-- Domains First -->
	<xsl:value-of select="$indent"/><xsl:text>Domains </xsl:text>[<xsl:value-of select="count(Domains/Domain)"/>]<xsl:text>&#xa;</xsl:text>
	<!-- header -->
	<xsl:value-of select="$underline"/>
	<!-- if there are no domains add an empty line -->
	<xsl:if test="count(Domains/Domain) = 0">
		<xsl:value-of select="$_newLine"/>
	</xsl:if>
	<xsl:for-each select="Domains/Domain">
		<xsl:sort select="DomainName"/>
		<xsl:apply-templates select="."/>
	</xsl:for-each>
	
	<!-- Datasets -->
	<xsl:value-of select="$indent"/><xsl:text>Datasets</xsl:text><xsl:value-of select="$_newLine"/>
	<!-- header -->
	<xsl:value-of select="$underline"/>
	<!-- if there are no datasets add an empty line -->
	<xsl:if test="count(DatasetDefinitions/DataElement) = 0">
		<xsl:value-of select="$_newLine"/>
	</xsl:if>
	
	<!-- Feature datasets first -->
<xsl:for-each select="DatasetDefinitions/DataElement[@xsi:type='esri:DEFeatureDataset']">
		<xsl:sort select="Name"/>
		<xsl:apply-templates select="."/>
	</xsl:for-each>
	<!-- Feature classes -->
	<xsl:for-each select="DatasetDefinitions/DataElement[@xsi:type='esri:DEFeatureClass']">
		<xsl:sort select="Name"/>
		<xsl:apply-templates select="."/>
	</xsl:for-each>
	<!-- Raster datasets  -->
	<xsl:for-each select="DatasetDefinitions/DataElement[@xsi:type='esri:DERasterDataset']">
		<xsl:sort select="Name"/>
		<xsl:apply-templates select="."/>
	</xsl:for-each>
	<!-- Raster catalogs -->
	<xsl:for-each select="DatasetDefinitions/DataElement[@xsi:type='esri:DERasterCatalog']">
		<xsl:sort select="Name"/>
		<xsl:apply-templates select="."/>
	</xsl:for-each>
	<!-- Raster bands -->
	<xsl:for-each select="DatasetDefinitions/DataElement[@xsi:type='esri:DERasterBand']">
		<xsl:sort select="Name"/>
		<xsl:apply-templates select="."/>
	</xsl:for-each>
	<!-- Network datasets -->
	<xsl:for-each select="DatasetDefinitions/DataElement[@xsi:type='esri:DENetworkDataset']">
		<xsl:sort select="Name"/>
		<xsl:apply-templates select="."/>
	</xsl:for-each>
	<!-- Geometric networks -->
	<xsl:for-each select="DatasetDefinitions/DataElement[@xsi:type='esri:DEGeometricNetwork']">
		<xsl:sort select="Name"/>
		<xsl:apply-templates select="."/>
	</xsl:for-each>
	<!-- Topology -->
	<xsl:for-each select="DatasetDefinitions/DataElement[@xsi:type='esri:DETopology']">
		<xsl:sort select="Name"/>
		<xsl:apply-templates select="."/>
	</xsl:for-each>
	<!-- Cadastral fabric -->
	<xsl:for-each select="DatasetDefinitions/DataElement[@xsi:type='esri:DECadastralFabric']">
		<xsl:sort select="Name"/>
		<xsl:apply-templates select="."/>
	</xsl:for-each>
	<!-- Terrain -->
	<xsl:for-each select="DatasetDefinitions/DataElement[@xsi:type='esri:DETerrain']">
		<xsl:sort select="Name"/>
		<xsl:apply-templates select="."/>
	</xsl:for-each>
	<!-- Representations -->
	<xsl:for-each select="DatasetDefinitions/DataElement[@xsi:type='esri:DERepresentationClass']">
		<xsl:sort select="Name"/>
		<xsl:apply-templates select="."/>
	</xsl:for-each>
	<!-- Cadastral fabric -->
	<xsl:for-each select="DatasetDefinitions/DataElement[@xsi:type='esri:DERelationshipClass']">
		<xsl:sort select="Name"/>
		<xsl:apply-templates select="."/>
	</xsl:for-each>
	<!-- Tables -->
	<xsl:for-each select="DatasetDefinitions/DataElement[@xsi:type='esri:DETable']">
		<xsl:sort select="Name"/>
		<xsl:apply-templates select="."/>
	</xsl:for-each>
	
	<!-- footer -->
	<xsl:text/><xsl:value-of select="$underline"/>
	<xsl:text>                NOTHING  FOLLOWS</xsl:text>
</xsl:template>

<!-- we output nothing for these -->
<xsl:template match="WorkspaceData"/>
<xsl:template match="Metadata"/>
<xsl:template match="XmlDoc"/>
<xsl:template match="Geometry"/>
<xsl:template match="MetadataRetrieved"/>

<!-- Format the Domain element and its children
		Domains can be: RangeDomain, CodedValueDomain, BitMaskCodedValueDomain
-->
<xsl:template match="Domain">
	<xsl:variable name="domainIndent">
		<xsl:value-of select="substring($spacer,1,count(ancestor::*) - 2)"/>
	</xsl:variable>
	<!-- The name of the domain quoted -->
	<xsl:call-template name="colFormat">
		<!-- provide the appropriate indent -->
		<xsl:with-param name="margin" select="$domainIndent"/>
		<xsl:with-param name="colName" select=" 'Domain' "/>
		<xsl:with-param name="colValue" select="DomainName"/>
		<xsl:with-param name="wd" select="$colWidth"/>
	</xsl:call-template>		
	
	<!-- All domains have these fields - print out each as a name: value pair -->
	<xsl:for-each select="*[local-name() != 'CodedValues' and local-name() != 'DomainName' ]">
		<xsl:sort select="local-name(.)"/>
		<!--xsl:if test="local-name() != 'DomainName'"-->	
			<xsl:call-template name="colFormat">
				<!-- provide the appropriate indent -->
				<xsl:with-param name="margin" select="$domainIndent"/>
				<xsl:with-param name="colName" select="local-name(.)"/>
				<xsl:with-param name="colValue" select="."/>
				<xsl:with-param name="wd" select="$colWidth"/>
			</xsl:call-template>
		<!--/xsl:if -->
	</xsl:for-each>	
	<!-- figure out the type of domain -->
	<xsl:choose>
		<xsl:when test="@xsi:type='esri:CodedValueDomain'">
			<!-- list out the values -->
			<xsl:value-of select="$domainIndent"/><xsl:text>CodedValues  [</xsl:text><xsl:value-of select="count(CodedValues/CodedValue)"/>]:<xsl:value-of select="$_newLine"/>
				<xsl:for-each select="CodedValues/CodedValue">
					<xsl:sort data-type="number" select="Code"/>
					<!-- list out the Code and CodeValue pairs - one per line. The Value is single quoted -->
					<xsl:value-of select="concat($domainIndent,$indent,Code,' &quot;',Name,'&quot;')"/><xsl:value-of select="$_newLine"/>
					<!--xsl:value-of select="concat(concat(concat(concat(concat($domainIndent,$indent),Code),'  '''),Name),'''')"/><xsl:value-of select="$_newLine"/-->
				</xsl:for-each>
		</xsl:when>
		<xsl:when test="@xsi:type='esri:RangeDomain'">
			<!-- list out the values -->
			<xsl:value-of select="concat($domainIndent,$indent,'MaxValue  ',MaxValue)"/><xsl:value-of select="$_newLine"/>
			<xsl:value-of select="concat($domainIndent,$indent,'MinValue  ',MinValue)"/><xsl:value-of select="$_newLine"/>
		</xsl:when>
	</xsl:choose>
	<!-- space -->
	<xsl:value-of select="$_newLine"/>
</xsl:template>

<xsl:template match="Children[DataElement]">
	<!-- skip printing a "Children" tag -->
	<xsl:for-each select="*">
		<xsl:sort select="Name"/>
		<xsl:apply-templates select="."/>
	</xsl:for-each>
</xsl:template>

<!-- DatasetDefinitions -->
<xsl:template match="DataElement">
	<!-- indent -->
	<xsl:variable name="_indent">
		<xsl:value-of select="substring($spacer,1,count(ancestor::*))"/>
	</xsl:variable>
	<!-- get the DE dataset type and strip of the "esri:" bit -->
	<xsl:variable name="dsType">
		<xsl:call-template name="string-after">
			<xsl:with-param name="string" select="@xsi:type"/>
			<xsl:with-param name="find-what" select="'esri:'"/>
		</xsl:call-template>
	</xsl:variable>
	
	<!-- name the dataelement using  'type': 'name' -->
	<xsl:call-template name="colFormat">
		<!-- provide the appropriate indent -->
		<xsl:with-param name="margin" select="$_indent"/>
		<xsl:with-param name="colName" select="$dsType"/>
		<xsl:with-param name="colValue" select="Name"/>
		<xsl:with-param name="wd" select="$colWidth"/>
	</xsl:call-template>
	
	<!-- now all the elements - without children first -->	
	<!--xsl:apply-templates select="$printThese[count(. | $skipThese) != count($skipThese)]"/-->
	<xsl:for-each select="*[not(*) and local-name(.) != 'MetadataRetrieved' and local-name() != 'CatalogPath' and local-name() != 'DSID' and local-name() != 'SubtypeFieldName' and local-name() != 'DefaultSubtypeCode' ]">
		<xsl:call-template name="colFormat">
				<!-- provide the appropriate indent -->
				<xsl:with-param name="margin" select="$_indent"/>
				<xsl:with-param name="colName" select="local-name(.)"/>
				<xsl:with-param name="colValue" select="."/>
				<xsl:with-param name="wd" select="$colWidth"/>
			</xsl:call-template>
	</xsl:for-each>
	<!-- space -->
	<xsl:value-of select="$_newLine"/>
	<!-- Extent and Spatial Reference -->
	<xsl:apply-templates select="Extent"/>
	<xsl:apply-templates select="SpatialReference"/>

	<!-- now all the elements with children -->
	<xsl:apply-templates select="*[count(*) > 0 and local-name() != 'Extent' and local-name() != 'SpatialReference' and local-name() != 'Fields' and local-name() != 'Indexes' and local-name() != 'Subtypes' ]"/>
	
	<!-- Fields -->
	<xsl:if test="Fields/FieldArray/Field">
		<!-- Fields Heading -->
		<xsl:value-of select="concat($_indent,Name,'  Fields')"/><xsl:value-of select="$_newLine"/>
		
		<xsl:for-each select="Fields/FieldArray/Field">
			<xsl:call-template name="PrintField">
				<xsl:with-param name="_indent" select="concat($_indent,$indent)"/>
			</xsl:call-template>
		</xsl:for-each>
		<!-- space -->
		<xsl:value-of select="$_newLine"/>
	</xsl:if>
	
	<!-- Indexes -->
	<xsl:if test="Indexes/IndexArray/Index">
		<!-- Indexes Heading -->
		<xsl:value-of select="concat($_indent,Name,'  Indexes')"/><xsl:value-of select="$_newLine"/>
		
		<xsl:for-each select="Indexes/IndexArray/Index">
			<xsl:call-template name="PrintIndex">
				<xsl:with-param name="_indent" select="concat($_indent,$indent)"/>
			</xsl:call-template>
		</xsl:for-each>
		
		<!-- space -->
		<xsl:value-of select="$_newLine"/>
	</xsl:if>
	
	<!-- Subtypes -->
	<xsl:if test="Subtypes">
		<!-- Subtypes Heading -->
		<xsl:value-of select="concat($_indent,Name,'  Subtypes')"/><xsl:value-of select="$_newLine"/>			
	
		<xsl:apply-templates select="SubtypeFieldName"/>
		<xsl:apply-templates select="DefaultSubtypeCode"/>
		<xsl:for-each select="Subtypes/Subtype">
			<xsl:call-template name="PrintSubtype">
				<xsl:with-param name="_indent" select="concat($_indent,$indent)"/>
			</xsl:call-template>
		</xsl:for-each>
		<!-- space -->
		<xsl:value-of select="$_newLine"/>
	</xsl:if>
	
	<!-- end marker -->
	<xsl:text/><xsl:value-of select="concat($_indent,'::::::END  ',$dsType,'   ',Name)"/><xsl:value-of select="$_newLine"/>
</xsl:template>

<!-- relationship formatting -->
<xsl:template match="DataElement[@xsi:type='esri:DERelationshipClass']">
	<!-- indent -->
	<xsl:variable name="_indent">
		<xsl:value-of select="substring($spacer,1,count(ancestor::*))"/>
	</xsl:variable>
	
	<!-- name the dataelement using  'type': 'name' -->
	<xsl:call-template name="colFormat">
		<!-- provide the appropriate indent -->
		<xsl:with-param name="margin" select="$_indent"/>
		<xsl:with-param name="colName" select=" 'DERelationshipClass' "/>
		<xsl:with-param name="colValue" select="Name"/>
		<xsl:with-param name="wd" select="$colWidth"/>
	</xsl:call-template>
	
	<!-- mimic the order on the ArcCatalog relate property sheet -->
	<!-- relationship type first - simple or composite (i.e. cascade delete) -->
	<xsl:call-template name="colFormat">
		<!-- provide the appropriate indent -->
		<xsl:with-param name="margin" select="$_indent"/>
		<xsl:with-param name="colName" select=" 'Type' "/>
		<xsl:with-param name="colValue">
			<xsl:choose>
				<xsl:when test="IsComposite[. = 'true'] ">
					<xsl:text>Composite</xsl:text><xsl:text/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:text>Simple</xsl:text><xsl:text/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:with-param>
		<xsl:with-param name="wd" select="$colWidth"/>
	</xsl:call-template>
	
	<xsl:apply-templates select="Cardinality"/>
	<xsl:apply-templates select="Notification"/>
	<xsl:apply-templates select="IsAttributed"/>
	<xsl:apply-templates select="IsReflexive"/>
	<xsl:apply-templates select="KeyType"/>
	<xsl:apply-templates select="ClassKey"/>
	<!--xsl:apply-templates select="IsAttachmentRelationship"/-->
	
	<!-- Origin Table/Feature Class -->
	<xsl:value-of select="$_indent"/><xsl:text>Origin Table/Feature Class:</xsl:text><xsl:value-of select="$_newLine"/>
	
	<xsl:for-each select="OriginClassNames/Name">
		<xsl:call-template name="colFormat">
			<!-- provide the appropriate indent -->
			<xsl:with-param name="margin" select="concat($_indent,' ')"/>
			<xsl:with-param name="colName" select=" 'Name' "/>
			<xsl:with-param name="colValue" select="."/>
			<xsl:with-param name="wd" select="$colWidth"/>
		</xsl:call-template>
	</xsl:for-each>
	<!-- Origin keys -->
	<xsl:for-each select="OriginClassKeys/RelationshipClassKey">
		<xsl:call-template name="colFormat">
			<!-- provide the appropriate indent -->
			<xsl:with-param name="margin" select="concat($_indent,' ')"/>
			<xsl:with-param name="colName" select="ObjectKeyName"/>
			<xsl:with-param name="colValue" select="KeyRole"/>
			<xsl:with-param name="wd" select="$colWidth"/>
		</xsl:call-template>
		<xsl:if test="ClassKeyName != '' ">
				<xsl:apply-templates select="ClassKeyName"/>
		</xsl:if>
	</xsl:for-each>	
	
	<!-- Destination Table/Feature Class -->
	<xsl:value-of select="$_indent"/><xsl:text>Destination Table/Feature Class:</xsl:text><xsl:value-of select="$_newLine"/>
		<xsl:for-each select="DestinationClassNames/Name">
			<xsl:call-template name="colFormat">
				<!-- provide the appropriate indent -->
				<xsl:with-param name="margin" select="concat($_indent,' ')"/>
				<xsl:with-param name="colName" select=" 'Name' "/>
				<xsl:with-param name="colValue" select="."/>
				<xsl:with-param name="wd" select="$colWidth"/>
			</xsl:call-template>
	</xsl:for-each>

	<!-- Destination keys -->
	<xsl:for-each select="DestinationClassKeys/RelationshipClassKey">
		<xsl:call-template name="colFormat">
			<!-- provide the appropriate indent -->
			<xsl:with-param name="margin" select="concat($_indent,' ')"/>
			<xsl:with-param name="colName" select="ObjectKeyName"/>
			<xsl:with-param name="colValue" select="KeyRole"/>
			<xsl:with-param name="wd" select="$colWidth"/>
		</xsl:call-template>
		<xsl:if test="ClassKeyName != '' ">
				<xsl:apply-templates select="ClassKeyName"/>
		</xsl:if>
	</xsl:for-each>
			
	<!-- Labels -->
	<xsl:value-of select="$_indent"/><xsl:text>Labels:</xsl:text><xsl:value-of select="$_newLine"/>
	<xsl:apply-templates select="ForwardPathLabel"/>
	<xsl:apply-templates select="BackwardPathLabel"/>
	<!-- Rules -->
	<xsl:apply-templates select="RelationshipRules[RelationshipRule]"/>
	
	<!-- Fields (if the relate has any) -->
	<xsl:if test="Fields/FieldArray/Field">
		<!-- Fields Heading -->
		<xsl:value-of select="concat($_indent,Name,'  Fields')"/><xsl:value-of select="$_newLine"/>
		
		<xsl:for-each select="Fields/FieldArray/Field">
			<xsl:call-template name="PrintField">
				<xsl:with-param name="_indent" select="concat($_indent,$indent)"/>
			</xsl:call-template>
		</xsl:for-each>
		<!-- space -->
		<xsl:value-of select="$_newLine"/>
	</xsl:if>
	
		<!-- end marker -->
	<xsl:text/><xsl:value-of select="concat($_indent,'::::::END  DERelationshipClass','   ',Name)"/><xsl:value-of select="$_newLine"/>
</xsl:template>

<!-- Fields -->
<!--xsl:template match="Fields/FieldArray/Field"-->
<xsl:template name="PrintField">
	<xsl:param name="_indent"/>
	
	<!-- Field Name -->
	<xsl:text/><xsl:value-of select="$_indent"/>[<xsl:value-of select="Name"/>]<xsl:text/>
	<!-- space for alignment Note: the "-2" is for the brackets [] on the [field name]-->
	<xsl:value-of select="substring($spacer,1,$colWidth - string-length(Name) - string-length($_indent) - 2)"/><xsl:text/>
	
	<!-- Field Definition -->	
	<xsl:text/>(<xsl:value-of select="Type"/><xsl:text/>
	<xsl:if test="GeometryDef">
		<!-- this is a shape field -->
		<xsl:text> (</xsl:text><xsl:value-of select="GeometryDef/GeometryType"/><xsl:text>)</xsl:text>
	</xsl:if>
	<xsl:if test="Type = 'esriFieldTypeString' ">
		<xsl:text>(</xsl:text><xsl:value-of select="Length"/><xsl:text>)</xsl:text>
	</xsl:if>
	<!-- nullable -->
	<xsl:choose>
		<xsl:when test="IsNullable = 'true' "><xsl:text> null</xsl:text></xsl:when>
		<xsl:otherwise><xsl:text> not null</xsl:text></xsl:otherwise>
	</xsl:choose>
	<!-- required -->
	<xsl:if test="Required[. = 'true'] ">
		<xsl:text>, required</xsl:text>
	</xsl:if>
	<!-- editable -->
	<xsl:if test="Editable[. = 'false'] ">
		<xsl:text>, readonly</xsl:text>
	</xsl:if>
	<!-- alias -->
	<xsl:if test="AliasName[. != '' ]">
			<xsl:text>, alias: [</xsl:text><xsl:value-of select="AliasName"/>]<xsl:text/>
		</xsl:if>
	<!-- model -->
	<xsl:if test="ModelName[. != '' ]">
		<xsl:text>, model: [</xsl:text><xsl:value-of select="ModelName"/>]<xsl:text/>
	</xsl:if>
	<!-- Domain -->
	<xsl:if test="Domain/DomainName[. != '' ]">
		<xsl:text>, domain: [</xsl:text><xsl:value-of select="Domain/DomainName"/>]<xsl:text/>
		<xsl:if test="DomainFixed[. = 'true' ]">
			<xsl:text> (fixed)</xsl:text>
		</xsl:if>
	</xsl:if>
	
	<!-- grid dimensions if present -->
	<xsl:if test="GeometryDef/GridSize0">
		<!-- this is a shape field -->
		<xsl:text>, grid0=</xsl:text><xsl:value-of select="GeometryDef/GridSize0"/><xsl:text/>
			<xsl:if test="GeometryDef/GridSize1">
				<!-- this is a shape field -->
				<xsl:text>, grid1=</xsl:text><xsl:value-of select="GeometryDef/GridSize1"/><xsl:text/>
				<xsl:if test="GeometryDef/GridSize2">
					<!-- this is a shape field -->
					<xsl:text>, grid2=</xsl:text><xsl:value-of select="GeometryDef/GridSize2"/><xsl:text/>
				</xsl:if>
			</xsl:if>
	</xsl:if>
	<xsl:text>)</xsl:text><xsl:text/>
	
	<xsl:value-of select="$_newLine"/>
	
	<!-- raster def if present is on a new line-->
	<xsl:if test="RasterDef">
		<xsl:apply-templates select="RasterDef"/>
	</xsl:if>
</xsl:template>

<!-- Indexes -->
<!--xsl:template match="Indexes/IndexArray/Index"-->
<xsl:template name="PrintIndex">
	<xsl:param name="_indent"/>
	
	<!-- Name -->
	<xsl:text/><xsl:value-of select="$_indent"/>[<xsl:value-of select="Name"/>]<xsl:text/>
	<!-- space for alignment -->
	<xsl:value-of select="substring($spacer,1,$colWidth - string-length(Name) - string-length($_indent) - 2)"/><xsl:text/>
	
	<xsl:text>(</xsl:text><xsl:text/>
		<!-- unique? -->
		<xsl:choose>
			<xsl:when test="IsUnique = 'true' "><xsl:text> unique</xsl:text></xsl:when>
			<xsl:otherwise><xsl:text> not unique</xsl:text></xsl:otherwise>
		</xsl:choose>
		<!-- sort order -->
		<xsl:choose>
			<xsl:when test="IsAscending = 'true' "><xsl:text>, asc</xsl:text></xsl:when>
			<xsl:otherwise><xsl:text>, desc</xsl:text></xsl:otherwise>
		</xsl:choose>
		
		<!-- field list -->
		<xsl:for-each select="Fields/FieldArray/Field">
			<xsl:text>, </xsl:text>[<xsl:value-of select="Name"/>]<xsl:text/>
		</xsl:for-each>
	<xsl:text>)</xsl:text><xsl:text/>
	
	<!-- spacer -->
	<xsl:value-of select="$_newLine"/>
</xsl:template>

<!-- Subtypes -->
<!--xsl:template match="Subtypes/Subtype"-->
<xsl:template name="PrintSubtype">
	<xsl:param name="_indent"/>

	<!-- Subtypes Heading -->
	<xsl:call-template name="colFormat">
		<!-- provide the appropriate indent -->
		<xsl:with-param name="margin" select="$_indent"/>
		<xsl:with-param name="colName" select=" 'Subtype' "/>
		<xsl:with-param name="colValue" select=" SubtypeName "/>
		<xsl:with-param name="wd" select="$colWidth"/>
	</xsl:call-template>
	<!-- code -->
	<xsl:apply-templates select="SubtypeCode"/>
	<!-- Field information -->
	<xsl:for-each select="FieldInfos/SubtypeFieldInfo">
			<!-- print out the field information as a single line -->
			<xsl:call-template name="colFormat">
				<!-- provide the appropriate indent -->
				<xsl:with-param name="margin" select="concat($_indent,$indent)"/>
				<xsl:with-param name="colName" select=" 'SubtypeFieldInfo' "/>
				<xsl:with-param name="colValue">
					<xsl:choose>
						<xsl:when test="DomainName">
							<xsl:text/>Field: <xsl:value-of select="FieldName"/>, Default: <xsl:value-of select="DefaultValue"/>, Domain: <xsl:value-of select="DomainName"/><xsl:text/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:text/>Field: <xsl:value-of select="FieldName"/>, Default: <xsl:value-of select="DefaultValue"/><xsl:text/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:with-param>
				<xsl:with-param name="wd" select="$colWidth"/>
			</xsl:call-template>
	</xsl:for-each>
</xsl:template>

<!-- Representation Rules -->
<xsl:template match="Rules[RepresentationRuleInfo]">
	<!-- indent -->
	<xsl:variable name="_indent">
		<xsl:value-of select="substring($spacer,1,count(ancestor::*))"/>
	</xsl:variable>
	<!-- Rules Heading -->
	<xsl:value-of select="concat($_indent,../Name,'  Rules')"/><xsl:value-of select="$_newLine"/>	
	
	<xsl:for-each select="RepresentationRuleInfo">
			<xsl:sort select="RuleID" data-type="number"/>
			<!-- Name and ID -->
			<xsl:apply-templates select="RuleName"/>
			<xsl:apply-templates select="RuleID"/>
			<!-- Sub heading - Rules then indented underneath 'Layers' -->
			<xsl:value-of select="concat($_indent,$indent,'Rule')"/><xsl:value-of select="$_newLine"/>
			<xsl:value-of select="concat($_indent,$indent,$indent,'Layers')"/><xsl:value-of select="$_newLine"/>
			<!-- now print out the rules (abbreviated) -->
			<xsl:for-each select="Rule/Layers/BasicSymbol">
					<xsl:call-template name="colFormat">
						<!-- provide the appropriate indent -->
						<xsl:with-param name="margin" select="concat($_indent,$indent,$indent,$indent)"/>
						<xsl:with-param name="colName" select=" 'BasicSymbol' "/>
						<xsl:with-param name="colValue" select="@xsi:type"/>
						<xsl:with-param name="wd" select="$colWidth"/>
					</xsl:call-template>
			</xsl:for-each>
			
	</xsl:for-each>
	<!-- spacer -->
	<xsl:value-of select="$_newLine"/>
</xsl:template>

<!-- Extent -->
<xsl:template match="Extent">
	<!-- indent -->
	<xsl:variable name="_indent">
		<xsl:value-of select="substring($spacer,1,count(ancestor::*))"/>
	</xsl:variable>
	<!-- get the SREF  type and strip of the "esri:" bit -->
	<xsl:variable name="srType">
		<xsl:call-template name="string-after">
			<xsl:with-param name="string" select="@xsi:type"/>
			<xsl:with-param name="find-what" select="'esri:'"/>
		</xsl:call-template>
	</xsl:variable>
	<!-- get the envelope -->
	<!--xsl:variable name="_envelope">
	<xsl:text>(</xsl:text><xsl:value-of select="XMin"/>,<xsl:value-of select="YMin"/>),(<xsl:value-of select="XMax"/>,<xsl:value-of select="YMax"/><xsl:text>)</xsl:text><xsl:text/>
	</xsl:variable-->
	
	<!--output the envelope -->
	<xsl:call-template name="colFormat">
		<!-- provide the appropriate indent -->
		<xsl:with-param name="margin" select="$_indent"/>
		<xsl:with-param name="colName" select=" 'Extent' "/>
		<xsl:with-param name="colValue">
			<xsl:text>(</xsl:text><xsl:value-of select="XMin"/>,<xsl:value-of select="YMin"/>),(<xsl:value-of select="XMax"/>,<xsl:value-of select="YMax"/><xsl:text>)</xsl:text>		
		</xsl:with-param>
		<xsl:with-param name="wd" select="$colWidth"/>
	</xsl:call-template>
	
	<!-- all the rest -->
	<xsl:for-each select="*[not(*) and local-name(.) != 'XMin' and local-name() != 'YMin' and local-name() != 'XMax' and local-name() != 'YMax' ]">
		<xsl:call-template name="colFormat">
			<!-- provide the appropriate indent -->
			<xsl:with-param name="margin" select="concat($_indent,$indent)"/>
			<xsl:with-param name="colName" select="local-name(.)"/>
			<xsl:with-param name="colValue" select="."/>
			<xsl:with-param name="wd" select="$colWidth"/>
		</xsl:call-template>		
	</xsl:for-each>
	<!-- spatial reference -->
	<!--xsl:apply-templates select="SpatialReference"/-->
	
	<!-- spacer -->
	<xsl:value-of select="$_newLine"/>
</xsl:template>

<!-- Spatial Reference -->
<xsl:template match="SpatialReference">
	<!-- indent -->
	<xsl:variable name="_indent">
		<xsl:value-of select="substring($spacer,1,count(ancestor::*))"/>
	</xsl:variable>
	<!-- get the SREF  type and strip of the "esri:" bit -->
	<xsl:variable name="srType">
		<xsl:call-template name="string-after">
			<xsl:with-param name="string" select="@xsi:type"/>
			<xsl:with-param name="find-what" select="'esri:'"/>
		</xsl:call-template>
	</xsl:variable>
	
	<!-- name the SREF using  'SpatialReference': 'type' -->
	<xsl:call-template name="colFormat">
		<!-- provide the appropriate indent -->
		<xsl:with-param name="margin" select="$_indent"/>
		<xsl:with-param name="colName" select=" 'SpatialReference' "/>
		<xsl:with-param name="colValue" select="$srType"/>
		<xsl:with-param name="wd" select="$colWidth"/>
	</xsl:call-template>

	<!-- WKID -->
	<xsl:apply-templates select="WKID"/>
	<!-- Origin -->
	<xsl:call-template name="colFormat">
		<!-- provide the appropriate indent -->
		<xsl:with-param name="margin" select="concat($_indent,$indent)"/>
		<xsl:with-param name="colName" select=" 'Origin' "/>
		<xsl:with-param name="colValue">
			<xsl:if test="(XOrigin != '') and (YOrigin != '')">
					<xsl:text>(</xsl:text><xsl:value-of select="XOrigin"/><xsl:text>,</xsl:text><xsl:value-of select="YOrigin"/><xsl:text>)</xsl:text><xsl:text/>
			</xsl:if>
		</xsl:with-param>
		<xsl:with-param name="wd" select="$colWidth"/>
	</xsl:call-template>
	<!-- SREF "WKT" definition string -->
	<xsl:apply-templates select="WKT"/>
	
	<!-- all the rest -->
	<xsl:apply-templates select="*[not(*) and local-name(.) != 'WKID' and local-name() != 'WKT' and local-name() != 'XOrigin' and local-name() != 'YOrigin']"/>
	<!-- spacer -->
	<xsl:value-of select="$_newLine"/>
</xsl:template>

<!-- Graphic Attribute with no children for the value -->
<xsl:template match="GraphicAttribute[count(Value/*) = 0]">

	<xsl:variable name="value">
		<xsl:text/><xsl:value-of select="Name"/><xsl:text>, </xsl:text><xsl:value-of select="Value"/><xsl:text/>
	</xsl:variable>
	<xsl:call-template name="colFormat">
		<!-- provide the appropriate indent -->
		<xsl:with-param name="margin">
			<xsl:value-of select="substring($spacer,1,count(ancestor::*))"/>
		</xsl:with-param>
		<xsl:with-param name="colName" select=" 'GraphicAttribute' "/>
		<xsl:with-param name="colValue" select="$value"/>
		<xsl:with-param name="wd" select="$colWidth"/>
	</xsl:call-template>
</xsl:template>

<!-- Generic template to print out the name of the element and its value (if it
     has one.....)
-->
<xsl:template match="*[not(*)]">
	
    <!-- format the name/value pair for the element -->
	<xsl:call-template name="colFormat">
		<!-- provide the appropriate indent -->
		<xsl:with-param name="margin">
			<xsl:value-of select="substring($spacer,1,count(ancestor::*) - 1)"/>
		</xsl:with-param>
		<xsl:with-param name="colName" select="local-name(.)"/>
		<xsl:with-param name="colValue" select="."/>
		<xsl:with-param name="wd" select="$colWidth"/>
	</xsl:call-template>
</xsl:template>

<!-- Default template for elements with children -->
<xsl:template match="*">
	<xsl:variable name="indent">
		<xsl:value-of select="substring($spacer,1,count(ancestor::*))"/>
	</xsl:variable>
	<xsl:value-of select="$indent"/><xsl:value-of select="local-name(.)"/><xsl:value-of select="$_newLine"/>

	<!-- children -->
	<xsl:apply-templates select="*"/>
</xsl:template>

<!-- Print out the schema stats -->
<xsl:template name="stats">
	<xsl:param name="_wsDef"/>
	
	<xsl:value-of select="$indent"/><xsl:text>Stats</xsl:text><xsl:value-of select="$_newLine"/>
	
	<xsl:call-template name="colFormat">
		<!-- provide the appropriate indent -->
		<xsl:with-param name="margin" select="concat($indent,$indent)"/>
		<xsl:with-param name="colName" select=" 'Domains' "/>
		<xsl:with-param name="colValue" select="string(count(Domains/Domain))"/>
		<xsl:with-param name="wd" select="$colWidth"/>
	</xsl:call-template>
	
	<xsl:call-template name="colFormat">
		<!-- provide the appropriate indent -->
		<xsl:with-param name="margin" select="concat($indent,$indent)"/>
		<xsl:with-param name="colName" select=" 'Feature Datasets' "/>
		<xsl:with-param name="colValue" select="string(count(DatasetDefinitions/DataElement[@xsi:type='esri:DEFeatureDataset']))"/>
		<xsl:with-param name="wd" select="$colWidth"/>
	</xsl:call-template>
	
	<xsl:call-template name="colFormat">
		<!-- provide the appropriate indent -->
		<xsl:with-param name="margin" select="concat($indent,$indent)"/>
		<xsl:with-param name="colName" select=" 'Feature Classes' "/>
		<xsl:with-param name="colValue" select="string(count(//DataElement[@xsi:type='esri:DEFeatureClass']))"/>
		<xsl:with-param name="wd" select="$colWidth"/>
	</xsl:call-template>

	<xsl:call-template name="colFormat">
		<!-- provide the appropriate indent -->
		<xsl:with-param name="margin" select="concat($indent,$indent)"/>
		<xsl:with-param name="colName" select=" 'Representations' "/>
		<xsl:with-param name="colValue" select="string(count(//DataElement[@xsi:type='esri:DERepresentationClass']))"/>
		<xsl:with-param name="wd" select="$colWidth"/>
	</xsl:call-template>
	
	<xsl:call-template name="colFormat">
		<!-- provide the appropriate indent -->
		<xsl:with-param name="margin" select="concat($indent,$indent)"/>
		<xsl:with-param name="colName" select=" 'Raster Datasets' "/>
		<xsl:with-param name="colValue" select="string(count(//DataElement[@xsi:type='esri:DERasterDataset']))"/>
		<xsl:with-param name="wd" select="$colWidth"/>
	</xsl:call-template>
	
	<xsl:call-template name="colFormat">
		<!-- provide the appropriate indent -->
		<xsl:with-param name="margin" select="concat($indent,$indent)"/>
		<xsl:with-param name="colName" select=" 'Raster Catalogs' "/>
		<xsl:with-param name="colValue" select="string(count(//DataElement[@xsi:type='esri:DERasterCatalog']))"/>
		<xsl:with-param name="wd" select="$colWidth"/>
	</xsl:call-template>
	
	<xsl:call-template name="colFormat">
		<!-- provide the appropriate indent -->
		<xsl:with-param name="margin" select="concat($indent,$indent)"/>
		<xsl:with-param name="colName" select=" 'Raster Bands' "/>
		<xsl:with-param name="colValue" select="string(count(//DataElement[@xsi:type='esri:DERasterBand']))"/>
		<xsl:with-param name="wd" select="$colWidth"/>
	</xsl:call-template>
	
	<xsl:call-template name="colFormat">
		<!-- provide the appropriate indent -->
		<xsl:with-param name="margin" select="concat($indent,$indent)"/>
		<xsl:with-param name="colName" select=" 'Network Datasets' "/>
		<xsl:with-param name="colValue" select="string(count(//DataElement[@xsi:type='esri:DENetworkDataset']))"/>
		<xsl:with-param name="wd" select="$colWidth"/>
	</xsl:call-template>
	
	<xsl:call-template name="colFormat">
		<!-- provide the appropriate indent -->
		<xsl:with-param name="margin" select="concat($indent,$indent)"/>
		<xsl:with-param name="colName" select=" 'Geometric Networks' "/>
		<xsl:with-param name="colValue" select="string(count(//DataElement[@xsi:type='esri:DEGeometricNetwork']))"/>
		<xsl:with-param name="wd" select="$colWidth"/>
	</xsl:call-template>
	
	<xsl:call-template name="colFormat">
		<!-- provide the appropriate indent -->
		<xsl:with-param name="margin" select="concat($indent,$indent)"/>
		<xsl:with-param name="colName" select=" 'Topologies' "/>
		<xsl:with-param name="colValue" select="string(count(//DataElement[@xsi:type='esri:DETopology']))"/>
		<xsl:with-param name="wd" select="$colWidth"/>
	</xsl:call-template>
	
	<xsl:call-template name="colFormat">
		<!-- provide the appropriate indent -->
		<xsl:with-param name="margin" select="concat($indent,$indent)"/>
		<xsl:with-param name="colName" select=" 'Cadastral Fabrics' "/>
		<xsl:with-param name="colValue" select="string(count(//DataElement[@xsi:type='esri:DECadastralFabric']))"/>
		<xsl:with-param name="wd" select="$colWidth"/>
	</xsl:call-template>
	
	<xsl:call-template name="colFormat">
		<!-- provide the appropriate indent -->
		<xsl:with-param name="margin" select="concat($indent,$indent)"/>
		<xsl:with-param name="colName" select=" 'Terrains' "/>
		<xsl:with-param name="colValue" select="string(count(//DataElement[@xsi:type='esri:DETerrain']))"/>
		<xsl:with-param name="wd" select="$colWidth"/>
	</xsl:call-template>

	<xsl:call-template name="colFormat">
		<!-- provide the appropriate indent -->
		<xsl:with-param name="margin" select="concat($indent,$indent)"/>
		<xsl:with-param name="colName" select=" 'Relationship Classes' "/>
		<xsl:with-param name="colValue" select="string(count(//DataElement[@xsi:type='esri:DERelationshipClass']))"/>
		<xsl:with-param name="wd" select="$colWidth"/>
	</xsl:call-template>
	
	<xsl:call-template name="colFormat">
		<!-- provide the appropriate indent -->
		<xsl:with-param name="margin" select="concat($indent,$indent)"/>
		<xsl:with-param name="colName" select=" 'Tables' "/>
		<xsl:with-param name="colValue" select="string(count(//DataElement[@xsi:type='esri:DETable']))"/>
		<xsl:with-param name="wd" select="$colWidth"/>
	</xsl:call-template>
	<xsl:value-of select="$_newLine"/>
</xsl:template>

<!-- ================================================================== -->
<!-- Utility templates -->
<xsl:template name="colFormat">
	<xsl:param name="margin" select = " ' ' "/>
	<xsl:param name="colName" select=" '' "/>
	<xsl:param name="colValue" select=" '' "/>
	<xsl:param name="wd" select="22"/>
	
	<!-- format the output -->
	<xsl:value-of select="$margin"/><xsl:value-of select="$colName"/>:<xsl:text/>
	<xsl:if test="$colValue != ''">
		<!-- fill out the column to align the text 'nicely' 
              The "+1" is for the colon ":" placed after the "$colName" -->
		<xsl:value-of select="substring($spacer,1,$wd - (string-length($colName) + string-length($margin) +1))"/>
		<!-- Now the value..... -->
		<xsl:value-of select="$colValue"/><xsl:text/>
	</xsl:if>
	<xsl:text>&#xa;</xsl:text><xsl:text/>	
</xsl:template>

<!-- Duplicate the input string 'n' times -->
<xsl:template name="dup">
	<xsl:param name="input"/>
	<xsl:param name="count" select="1"/>
	<xsl:choose>
		<xsl:when test="not($count) or not($input)"></xsl:when>
		<xsl:when test="$count = 1">
			<xsl:value-of select="$input"/>
		</xsl:when>
		<xsl:otherwise>
			<!-- if count is odd, append an extra copy of input -->
			<xsl:if test="$count mod 2">
				<xsl:value-of select="$input"/>
			</xsl:if>
			<!-- recursively apply template after doubling input -->
			<xsl:call-template name="dup">
				<xsl:with-param name="input" select="concat($input,$input)"/>
				<xsl:with-param name="count" select="floor($count div 2)"/>
			</xsl:call-template>
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>

	<!-- Case-insensitive searches for the occurence of one string within another. These are alternatives
	       to the ~standard~ xslt "substring-before() and substring-after() case-sensitive functions.
	       
	       Note: Contrary to the standard "substring-before() and substring-after()" behaviour, these functions return
	       the input string if the search string is not found (within the input string). substring-before() and substring-after()
	       return an empty (null) string.
	   -->
    <xsl:template name="string-before">
		<xsl:param name="string"/>
		<xsl:param name="find-what"/>
		
		<!-- lower case the string buffer and the search parameter -->
		<xsl:variable name="string-lc" select="translate($string,'ABCDEFGHIJKLMNOPQRSTUVWXYZ', 'abcdefghijklmnopqrstuvwxyz')"/>
		<xsl:variable name="find-what-lc" select="translate($find-what,
														'ABCDEFGHIJKLMNOPQRSTUVWXYZ', 'abcdefghijklmnopqrstuvwxyz')"/>

		<!-- search for the occurence of the search-string in the string buffer and return the string that is
		       before it. Use the index of the search-string to "find" it in the original -->
		<xsl:choose>
			<xsl:when test="$find-what-lc != '' and contains($string-lc,$find-what-lc)">
				<xsl:value-of select="substring($string,1,string-length(substring-before($string-lc,$find-what-lc)))"/>
			</xsl:when>
			<!-- search parameter does not occur within the string. Return the original (unlike "null" string for substring-before()) -->
			<xsl:otherwise>
				<xsl:value-of select="$string"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template name="string-after">
		<xsl:param name="string"/>
		<xsl:param name="find-what"/>
		
		<!-- lower case the string buffer and the search parameter -->
		<xsl:variable name="string-lc" select="translate($string,'ABCDEFGHIJKLMNOPQRSTUVWXYZ', 'abcdefghijklmnopqrstuvwxyz')"/>
		<xsl:variable name="find-what-lc" select="translate($find-what,
														'ABCDEFGHIJKLMNOPQRSTUVWXYZ', 'abcdefghijklmnopqrstuvwxyz')"/>

		<!-- search for the occurence of the search-string in the string buffer and return the string that is
		       after it. Use the index of the search-string to "find" it in the original -->
		<xsl:choose>
			<xsl:when test="$find-what-lc != '' and contains($string-lc,$find-what-lc)">
				<xsl:value-of select="substring($string,string-length(substring-before($string-lc,$find-what-lc))+string-length($find-what-lc)+1)"/>
			</xsl:when>
			<!-- search parameter does not occur within the string. Return the original (unlike "null" string for substring-after()) -->
			<xsl:otherwise>
				<xsl:value-of select="$string"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

</xsl:stylesheet>
