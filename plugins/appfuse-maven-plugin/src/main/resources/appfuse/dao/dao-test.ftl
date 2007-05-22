<#assign pojoNameLower = pojo.shortName.substring(0,1).toLowerCase()+pojo.shortName.substring(1)>
<#assign getIdMethodName = pojo.getGetterSignature(pojo.identifierProperty)>
package ${basepackage}.dao;

import ${appfusepackage}.dao.BaseDaoTestCase;
import ${basepackage}.model.${pojo.shortName};
import org.springframework.dao.DataAccessException;

import java.util.List;

public class ${pojo.shortName}DaoTest extends BaseDaoTestCase {
    private ${pojo.shortName}Dao ${pojoNameLower}Dao = null;

    public void set${pojo.shortName}Dao(${pojo.shortName}Dao ${pojoNameLower}Dao) {
        this.${pojoNameLower}Dao = ${pojoNameLower}Dao;
    }

    public void testAddAndRemove${pojo.shortName}() throws Exception {
        ${pojo.shortName} ${pojoNameLower} = new ${pojo.shortName}();

        // enter all required fields
<#foreach field in pojo.getAllPropertiesIterator()>
    <#foreach column in field.getColumnIterator()>
        <#if !field.equals(pojo.identifierProperty) && !column.nullable && !c2h.isCollection(field) && !c2h.isManyToOne(field)>
            <#lt/>        ${pojoNameLower}.set${pojo.getPropertyName(field)}(${data.getValueForJavaTest(field.value.typeName)}<#rt/>
            <#if field.value.typeName == "java.lang.String" && column.isUnique()><#lt/> + Math.random()</#if><#lt/>);
        </#if>
    </#foreach>
</#foreach>

        ${pojoNameLower} = ${pojoNameLower}Dao.save(${pojoNameLower});
        flush();

        ${pojoNameLower} = (${pojo.shortName}) ${pojoNameLower}Dao.get(${pojoNameLower}.${getIdMethodName}());

        assertNotNull(${pojoNameLower}.${getIdMethodName}());

        log.debug("removing ${pojoNameLower}...");

        ${pojoNameLower}Dao.remove(${pojoNameLower}.${getIdMethodName}());
        flush();

        try {
            ${pojoNameLower}Dao.get(${pojoNameLower}.${getIdMethodName}());
            fail("${pojo.shortName} found in database");
        } catch (DataAccessException dae) {
            log.debug("Expected exception: " + dae.getMessage());
            assertNotNull(dae);
        }
    }
}