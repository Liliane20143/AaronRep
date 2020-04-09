<aura:application extends="force:slds">
    <aura:attribute name="ordId" type="String"/>
    
    <aura:if isTrue="{!v.ordId != null}">
        <c:LineItemAttribute orderId="{!v.ordId}"/>
    </aura:if>
</aura:application>