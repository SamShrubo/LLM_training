import fitz  # PyMuPDF
from pdf2image import convert_from_path
import pytesseract
from PIL import Image
import os

'''
NOTE: This file is a work in progress and is not fully implemented and may not work
'''


def is_text_based_pdf(pdf_path):
    # This function attempts to determine if a PDF is text-based
    try:
        with fitz.open(pdf_path) as doc:
            for page in doc:
                if page.get_text():
                    return True
        return False
    except Exception as e:
        print(f"Error checking if PDF is text-based: {e}")
        return False

def convert_pdf_to_text(pdf_path, output_txt_path):
    text_content = ""

    if is_text_based_pdf(pdf_path):
        # Extract text from a text-based PDF
        with fitz.open(pdf_path) as doc:
            for page in doc:
                text_content += page.get_text()
    else:
        # Extract text from a scanned PDF
        images = convert_from_path(pdf_path)
        for image in images:
            text_content += pytesseract.image_to_string(image)
    
    # Save the extracted text to a txt file
    with open(output_txt_path, "w", encoding="utf-8") as text_file:
        text_file.write(text_content)

# Example usage
pdf_path = "C:\\Users\\samue\\Downloads\\lab3.pdf" 
output_txt_path = "output_text.txt"  # The text file where you want to save the extracted text
convert_pdf_to_text(pdf_path, output_txt_path)
