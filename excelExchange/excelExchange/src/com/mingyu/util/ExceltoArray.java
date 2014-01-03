package com.mingyu.util;

import java.io.FileInputStream;
import java.io.InputStream;

import jxl.Cell;
import jxl.Sheet;
import jxl.Workbook;

public class ExceltoArray {

	public ExceltoArray() {

	}

	public static String[][] read(String inputPath) {

		String[][] answer = null;

		try {
			Workbook workBook = null;
			// 构建Workbook对象 只读Workbook对象
			// 直接从本地文件创建Workbook
			// 从输入流创建Workbook
			InputStream inputStream = new FileInputStream(inputPath);
			workBook = Workbook.getWorkbook(inputStream);
			// Sheet(术语：工作表)就是Excel表格左下角的Sheet1,Sheet2,Sheet3但在程序中
			// Sheet的下标是从0开始的
			// 获取第一张Sheet表
			Sheet sheets = workBook.getSheet(0);
			// 获取Sheet表中所包含的总列数
			int sheetColumns = sheets.getColumns();
			// 获取Sheet表中所包含的总行数
			int sheetRows = sheets.getRows();
			// 获取指这下单元格的对象引用

			answer = new String[sheetRows][sheetColumns];

			for (int i = 0; i < sheetRows; i++) {
				for (int j = 0; j < sheetColumns; j++) {
					// 注意在读取时 i和j的位置。i代表行 j代表列。且列在前 行在后
					Cell cell = sheets.getCell(j, i);
					answer[i][j] = cell.getContents().toString();
				}
			}
		} catch (Exception e) {
			System.err.println("Reading Excel Wrong!");
		}
		return answer;
	}

	public static void main(String args[]) {
		String inputPath = "/Users/mingyu_zhao/Documents/test1.xls";
		ExceltoArray.read(inputPath);
	}

}
