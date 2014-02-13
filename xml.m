docNode = com.mathworks.xml.XMLUtils.createDocument('NMF_parameters')
docRootNode = docNode.getDocumentElement;
%docRootNode.setAttribute('attr_name','attr_value');

thisElement = docNode.createElement('sample_rate'); 
thisElement.appendChild(docNode.createTextNode(sprintf('%1',1)));
docRootNode.appendChild(thisElement);

for i=1:20
    thisElement = docNode.createElement('child_node'); 
    thisElement.appendChild(docNode.createTextNode(sprintf('%i',i)));
    docRootNode.appendChild(thisElement);
end
docNode.appendChild(docNode.createComment('this is a comment'));

xmlFileName = 'nmf_parameters';
xmlwrite(xmlFileName,docNode);
type(xmlFileName);