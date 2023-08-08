/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package lk.com.ttsl.ousdps.services.utils;

import java.awt.Color;
import com.lowagie.text.Font;
import com.lowagie.text.Rectangle;

import java.io.OutputStream;
import java.util.Iterator;

import javax.servlet.jsp.JspException;

import org.apache.commons.lang.ObjectUtils;
import org.displaytag.Messages;
import org.displaytag.exception.BaseNestableJspTagException;
import org.displaytag.exception.SeverityEnum;
import org.displaytag.export.BinaryExportView;

import com.lowagie.text.Cell;
import org.displaytag.model.Column;
import org.displaytag.model.ColumnIterator;
import org.displaytag.model.HeaderCell;
import org.displaytag.model.Row;
import org.displaytag.model.RowIterator;
import org.displaytag.model.TableModel;

import org.apache.commons.lang.StringUtils;

import com.lowagie.text.BadElementException;
import com.lowagie.text.Chunk;
import com.lowagie.text.Document;
import com.lowagie.text.DocumentException;

import com.lowagie.text.Element;
import com.lowagie.text.FontFactory;
import com.lowagie.text.HeaderFooter;
import com.lowagie.text.PageSize;
import com.lowagie.text.Phrase;
import com.lowagie.text.Table;
import com.lowagie.text.pdf.BaseFont;
import com.lowagie.text.pdf.PdfContentByte;
import com.lowagie.text.pdf.PdfPTable;
import com.lowagie.text.pdf.PdfPageEventHelper;
import com.lowagie.text.pdf.PdfTemplate;

import com.lowagie.text.pdf.PdfWriter;
import java.io.IOException;

/**
 *
 * @author Dinesh
 */
public class CustomPdfExportView implements BinaryExportView
{

    private TableModel model;
    private boolean exportFull;
    private boolean header;
    private boolean decorated;
    private Table tablePDF;
    private Font smallFont;
    private Font headerFont;

    @Override
    public void setParameters(TableModel tableModel, boolean exportFullList, boolean includeHeader, boolean decorateValues)
    {
        this.model = tableModel;
        this.exportFull = true;
        this.header = includeHeader;
        this.decorated = decorateValues;
    }

    protected void initTable() throws BadElementException
    {
        tablePDF = new Table(this.model.getNumberOfColumns());
        tablePDF.getDefaultCell().setVerticalAlignment(Element.ALIGN_TOP);
        tablePDF.setCellsFitPage(true);
        tablePDF.setWidth(100);

        tablePDF.setPadding(3);
        tablePDF.setSpacing(0);

        smallFont = FontFactory.getFont(FontFactory.HELVETICA, 7, Font.NORMAL, new Color(0, 0, 0));
        headerFont = FontFactory.getFont(FontFactory.HELVETICA, 12, Font.BOLD, new Color(192, 20, 25));
    }

    @Override
    public String getMimeType()
    {
        return "application/pdf"; //$NON-NLS-1$
    }

    protected void generatePDFTable() throws JspException, BadElementException
    {
        if (this.header)
        {
            generateHeaders();
        }
        tablePDF.endHeaders();
        generateRows();
    }

    @Override
    public void doExport(OutputStream out) throws JspException
    {
        try
        {
            // Initialize the table with the appropriate number of columns
            initTable();

            // Initialize the Document and register it with PdfWriter listener and the OutputStream
            Document document = new Document(PageSize.A2.rotate(), 40, 40, 40, 40);
            document.addCreationDate();

            HeaderFooter header = new HeaderFooter(new Phrase(this.model.getCaption(), headerFont), false);
            header.setBorder(Rectangle.NO_BORDER);
            header.setAlignment(Element.ALIGN_CENTER);

            HeaderFooter footer = new HeaderFooter(new Phrase("Page No - " + document.getPageNumber(), smallFont), true);
            footer.setBorder(Rectangle.NO_BORDER);
            footer.setAlignment(Element.ALIGN_CENTER);
            //footer.setBackgroundColor(new Color(206, 204, 207));

            PdfWriter.getInstance(document, out);

            // Fill the virtual PDF table with the necessary data
            generatePDFTable();
            document.open();
            document.setHeader(header);
            document.setFooter(footer);            
            document.add(this.tablePDF);
            document.close();

        }
        catch (DocumentException | JspException e)
        {
            throw new PdfGenerationException(e);
        }
    }

    protected void generateHeaders() throws BadElementException
    {
        Iterator<HeaderCell> iterator = this.model.getHeaderCellList().iterator();

        while (iterator.hasNext())
        {
            HeaderCell headerCell = iterator.next();

            String columnHeader = headerCell.getTitle();

            if (columnHeader == null)
            {
                columnHeader = StringUtils.capitalize(headerCell.getBeanPropertyName());
            }

            Cell hdrCell = getCell(columnHeader);
            hdrCell.setGrayFill(0.9f);
            hdrCell.setHeader(true);
            tablePDF.addCell(hdrCell);

        }
    }

    protected void generateRows() throws JspException, BadElementException
    {
        // get the correct iterator (full or partial list according to the exportFull field)
        RowIterator rowIterator = this.model.getRowIterator(this.exportFull);
        // iterator on rows
        while (rowIterator.hasNext())
        {
            Row row = rowIterator.next();

            // iterator on columns
            ColumnIterator columnIterator = row.getColumnIterator(this.model.getHeaderCellList());

            while (columnIterator.hasNext())
            {
                Column column = columnIterator.nextColumn();

                // Get the value to be displayed for the column
                Object value = column.getValue(this.decorated);

                Cell cell = getCell(ObjectUtils.toString(value));

                tablePDF.addCell(cell);
            }
        }
        Object value = this.model.getFooter().trim();

        Cell cell = getCell(ObjectUtils.toString(value).replace("\t", ""));
        cell.setBackgroundColor(new Color(206, 204, 207));
        cell.setGrayFill(0.9f);
        cell.setColspan(this.model.getHeaderCellList().size());
        cell.setVerticalAlignment(Element.ALIGN_TOP);
        cell.setHorizontalAlignment(Element.ALIGN_LEFT);
        cell.setLeading(8);

        tablePDF.addCell(cell);
    }

    private Cell getCell(String value) throws BadElementException
    {
        Cell cell = new Cell(new Chunk(StringUtils.trimToEmpty(value), smallFont));
        cell.setVerticalAlignment(Element.ALIGN_TOP);
        cell.setLeading(8);
        return cell;
    }

    static class PdfGenerationException extends BaseNestableJspTagException
    {

        private static final long serialVersionUID = 899149338534L;

        public PdfGenerationException(Throwable cause)
        {
            super(CustomPdfExportView.class, Messages.getString("PdfView.errorexporting"), cause); //$NON-NLS-1$
        }

        @Override
        public SeverityEnum getSeverity()
        {
            return SeverityEnum.ERROR;
        }
    }
    
    
    protected void initItextWriter(Document document, OutputStream out) throws DocumentException
    {
        PdfWriter.getInstance(document, out).setPageEvent(new CustomPdfExportView.PageNumber());
    }
    
    private static class PageNumber extends PdfPageEventHelper
    {

        /**
         * @see com.lowagie.text.pdf.PdfPageEventHelper#onEndPage(com.lowagie.text.pdf.PdfWriter,
         * com.lowagie.text.Document)
         */
        @Override
        public void onEndPage(PdfWriter writer, Document document)
        {
            /** The headertable. */
            PdfPTable table = new PdfPTable(2);
            /** A template that will hold the total number of pages. */
            PdfTemplate tpl = writer.getDirectContent().createTemplate(100, 100);
            /** The font that will be used. */
            BaseFont helv = null;
            try
            {
                helv = BaseFont.createFont("Helvetica", BaseFont.WINANSI, false);
            }
            catch (DocumentException | IOException e)
            {
            }
            PdfContentByte cb = writer.getDirectContent();
            cb.saveState();
            // write the headertable
            table.setTotalWidth(document.right() - document.left());
            table.writeSelectedRows(0, -1, document.left(), (document.getPageSize().getHeight() - 50), cb);
            // compose the footer
            String text = "Page " + writer.getPageNumber();
            float textSize = helv.getWidthPoint(text, 12);
            float textBase = document.bottom() - 20;
            cb.beginText();
            cb.setFontAndSize(helv, 12);
            float adjust = helv.getWidthPoint("0", 12);
            cb.setTextMatrix(document.right() - textSize - adjust, textBase);
            cb.showText(text);
            cb.endText();
            cb.addTemplate(tpl, document.right() - adjust, textBase);
            cb.saveState();
        }
    }
}
