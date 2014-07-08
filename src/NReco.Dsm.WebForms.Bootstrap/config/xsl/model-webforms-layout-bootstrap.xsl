<!--
NReco library (http://nreco.googlecode.com/)
Copyright 2008-2014 Vitaliy Fedorchenko
Distributed under the LGPL licence
 
Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
-->	
<xsl:stylesheet version='1.0' 
				xmlns:l="urn:schemas-nreco:webforms:layout:v2"
				xmlns:xsl='http://www.w3.org/1999/XSL/Transform' 
				xmlns:msxsl="urn:schemas-microsoft-com:xslt" 
				xmlns:NIData="urn:remove/NIData"
				xmlns:NRecoWebForms="urn:remove/NRecoWebForms"
				xmlns:asp="urn:remove/AspNet"
				xmlns:UserControl="urn:remove/UserControl"
				xmlns:UserControlEditor="urn:remove/UserControlEditor"
				exclude-result-prefixes="msxsl">

	<xsl:output method='xml' indent='yes' />


	<xsl:template match="l:tabs" mode="aspnet-renderer">
		<xsl:param name="context"/>
		<xsl:param name="mode"/>
		<xsl:param name="formUid"/>
		
		<xsl:variable name="uniqueId">
			<xsl:choose>
				<xsl:when test="@name"><xsl:value-of select="@name"/></xsl:when>
				<xsl:otherwise>tabs<xsl:value-of select="generate-id(.)"/></xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<ul id="{$uniqueId}" class="nav nav-tabs" role="tablist">
			<xsl:for-each select="l:tab">
				<xsl:variable name="tabUniqueId"><xsl:value-of select="$uniqueId"/>_<xsl:value-of select="position()"/></xsl:variable>

				<xsl:call-template name="apply-visibility">
					<xsl:with-param name="content">
						<li>
							<a href="#{$tabUniqueId}" role="tab" data-toggle="tab">
								<xsl:choose>
									<xsl:when test="@header">
										<NRecoWebForms:Label runat="server"><xsl:value-of select="@header"/></NRecoWebForms:Label>
									</xsl:when>
									<xsl:when test="l:header">
										<xsl:apply-templates select="l:header/l:*" mode="aspnet-renderer">
											<xsl:with-param name="context" select="$context"/>
											<xsl:with-param name="formUid" select="$formUid"/>
											<xsl:with-param name="mode" select="$mode"/>
										</xsl:apply-templates>										
									</xsl:when>
								</xsl:choose>								
							</a>
						</li>
					</xsl:with-param>
					<xsl:with-param name="expr" select="l:visible/node()"/>
				</xsl:call-template>
			</xsl:for-each>
		</ul>

		<div id="{$uniqueId}_content" class="tab-content">
			<xsl:for-each select="l:tab">
				<xsl:variable name="tabUniqueId"><xsl:value-of select="$uniqueId"/>_<xsl:value-of select="position()"/></xsl:variable>
				<xsl:call-template name="apply-visibility">
					<xsl:with-param name="content">
						<div class="tab-pane" id="{$tabUniqueId}">
							<xsl:apply-templates select="l:content/l:*" mode="aspnet-renderer">
								<xsl:with-param name="context" select="$context"/>
								<xsl:with-param name="formUid" select="$formUid"/>
								<xsl:with-param name="mode" select="$mode"/>
							</xsl:apply-templates>
						</div>
					</xsl:with-param>
					<xsl:with-param name="expr" select="l:visible/node()"/>
				</xsl:call-template>
			</xsl:for-each>
		</div>
		<NRecoWebForms:JavaScriptHolder runat="server">$(function() {
			$('#<xsl:value-of select="$uniqueId"/>@@gt;li:first,#<xsl:value-of select="$uniqueId"/>_content@@gt;div.tab-pane:first').addClass('active');
		});</NRecoWebForms:JavaScriptHolder>

	</xsl:template>
	
	<xsl:template match="l:accordion" mode="aspnet-renderer">
		<xsl:param name="context"/>
		<xsl:param name="mode"/>
		<xsl:param name="formUid"/>

		<xsl:variable name="uniqueId">
			<xsl:choose>
				<xsl:when test="@name"><xsl:value-of select="@name"/></xsl:when>
				<xsl:otherwise>accordion<xsl:value-of select="generate-id(.)"/></xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<NRecoWebForms:DataBindHolder runat="server">
		<div class="panel-group" id="{$uniqueId}">
			<xsl:for-each select="l:panel">
				<xsl:variable name="panelUniqueId"><xsl:value-of select="$uniqueId"/>_<xsl:value-of select="position()"/></xsl:variable>
				<xsl:variable name="collapsedClass">@@lt;%# Convert.ToBoolean(<xsl:apply-templates select="l:collapsed/l:*" mode="csharp-expr"><xsl:with-param name="context" select="$context"/></xsl:apply-templates>)?"":"in" %@@gt;</xsl:variable>
				
				<xsl:call-template name="apply-visibility">
					<xsl:with-param name="content">

						<div class="panel">
							<xsl:attribute name="class">
								panel <xsl:if test="@style">panel-<xsl:value-of select="@style"/></xsl:if> <xsl:if test="not(@style)">panel-default</xsl:if>
							</xsl:attribute>
							<div class="panel-heading">
								<h4 class="panel-title">
									<a data-toggle="collapse" data-parent="#{$uniqueId}" href="#{$panelUniqueId}">
										<xsl:choose>
											<xsl:when test="@header">
												<NRecoWebForms:Label runat="server"><xsl:value-of select="@header"/></NRecoWebForms:Label>
											</xsl:when>
											<xsl:when test="l:header">
												<xsl:apply-templates select="l:header/l:*" mode="aspnet-renderer">
													<xsl:with-param name="context" select="$context"/>
													<xsl:with-param name="formUid" select="$formUid"/>
													<xsl:with-param name="mode" select="$mode"/>
												</xsl:apply-templates>										
											</xsl:when>
										</xsl:choose>
									</a>
								</h4>
							</div>
							@@lt;div id="<xsl:value-of select="$panelUniqueId"/>" class="panel-collapse collapse <xsl:if test="l:collapsed"><xsl:value-of select="$collapsedClass" disable-output-escaping="yes"/></xsl:if>"@@gt;
								<div class="panel-body">
									<xsl:apply-templates select="l:body/l:*" mode="aspnet-renderer">
										<xsl:with-param name="context" select="$context"/>
										<xsl:with-param name="formUid" select="$formUid"/>
										<xsl:with-param name="mode" select="$mode"/>
									</xsl:apply-templates>							
								</div>
								<xsl:if test="l:footer">
									<div class="panel-footer">
										<xsl:apply-templates select="l:footer/l:*" mode="aspnet-renderer">
											<xsl:with-param name="context" select="$context"/>
											<xsl:with-param name="formUid" select="$formUid"/>
											<xsl:with-param name="mode" select="$mode"/>
										</xsl:apply-templates>
									</div>
								</xsl:if>						
							@@lt;/div@@gt;
						</div>
					</xsl:with-param>
					<xsl:with-param name="expr" select="l:visible/node()"/>
				</xsl:call-template>
			</xsl:for-each>
		</div>
		</NRecoWebForms:DataBindHolder>
	</xsl:template>
	
	
	<xsl:template match="l:panel" mode="aspnet-renderer">
		<xsl:param name="context"/>
		<xsl:param name="mode"/>
		<xsl:param name="formUid"/>
		
		<div class="panel">
			<xsl:attribute name="class">
				panel <xsl:if test="@style">panel-<xsl:value-of select="@style"/></xsl:if> <xsl:if test="not(@style)">panel-default</xsl:if>
			</xsl:attribute>

			<xsl:if test="l:header or @header">
				<div class="panel-heading">
					<xsl:choose>
						<xsl:when test="@header">
							<NRecoWebForms:Label runat="server"><xsl:value-of select="@header"/></NRecoWebForms:Label>
						</xsl:when>
						<xsl:when test="l:header">
							<xsl:apply-templates select="l:header/l:*" mode="aspnet-renderer">
								<xsl:with-param name="context" select="$context"/>
								<xsl:with-param name="formUid" select="$formUid"/>
								<xsl:with-param name="mode" select="$mode"/>
							</xsl:apply-templates>										
						</xsl:when>
					</xsl:choose>
				</div>	
			</xsl:if>

			<xsl:if test="l:body">
				<div class="panel-body">
					<xsl:apply-templates select="l:body/l:*" mode="aspnet-renderer">
						<xsl:with-param name="context" select="$context"/>
						<xsl:with-param name="formUid" select="$formUid"/>
						<xsl:with-param name="mode" select="$mode"/>
					</xsl:apply-templates>
				</div>
			</xsl:if>

			<xsl:if test="l:footer">
				<div class="panel-footer">
					<xsl:apply-templates select="l:footer/l:*" mode="aspnet-renderer">
						<xsl:with-param name="context" select="$context"/>
						<xsl:with-param name="formUid" select="$formUid"/>
						<xsl:with-param name="mode" select="$mode"/>
					</xsl:apply-templates>
				</div>
			</xsl:if>

		</div>
	</xsl:template>
	
</xsl:stylesheet>