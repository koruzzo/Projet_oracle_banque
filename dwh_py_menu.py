'''...'''
import tkinter as tk
import tkinter.ttk as ttk
import oracledb
import matplotlib.pyplot as plt
from matplotlib.backends.backend_tkagg import FigureCanvasTkAgg

from queries import (
    SELECT_CATEGORIE_D,
    SELECT_CATEGORIE_C,
    SELECT_SOLDE_CLIENT
)

def run_query(query):
    '''...'''
    cursor.execute(query)
    result = cursor.fetchone()
    return result

def display_result(result, label):
    '''...'''
    label.config(text=result)

def open_new_window():
    '''...'''
    def close_new_window():
        '''...'''
        print("Fermeture de la nouvelle fenêtre")
        new_window.destroy()

    new_window = tk.Toplevel(root)
    new_window.title("Évolution du solde client")
    new_window.geometry("800x600")
    new_window.protocol("WM_DELETE_WINDOW", close_new_window)

    cursor.execute(SELECT_SOLDE_CLIENT)
    results = cursor.fetchall()

    treeview_frame = tk.Frame(new_window)
    treeview_frame.pack(fill=tk.BOTH, expand=True)

    treeview = ttk.Treeview(treeview_frame, columns=('Date', 'Solde'), show='headings')
    treeview.heading('Date', text='Date')
    treeview.heading('Solde', text='Solde')
    treeview.pack(side=tk.LEFT, fill=tk.BOTH, expand=True)

    scrollbar = ttk.Scrollbar(treeview_frame, orient=tk.VERTICAL, command=treeview.yview)
    scrollbar.pack(side=tk.RIGHT, fill=tk.Y)
    treeview.configure(yscrollcommand=scrollbar.set)

    for row in results:
        treeview.insert('', 'end', values=row)

    dates = [row[0] for row in results]
    solde_clients = [row[1] for row in results]
    fig, ax = plt.subplots(figsize=(8, 6))
    ax.plot(dates, solde_clients, marker='o', linestyle='-', color='b')
    ax.set_title("Évolution du solde client dans le temps")
    ax.set_xlabel("Date")
    ax.set_ylabel("Solde client")
    ax.grid(True)

    canvas = FigureCanvasTkAgg(fig, master=new_window)
    canvas.draw()
    canvas.get_tk_widget().pack(side=tk.BOTTOM, fill=tk.BOTH, expand=True)

    scrollbar_canvas = tk.Scrollbar(new_window, orient=tk.VERTICAL,
                                    command=canvas.get_tk_widget().yview)
    scrollbar_canvas.pack(side=tk.RIGHT, fill=tk.Y)
    canvas.get_tk_widget().config(yscrollcommand=scrollbar_canvas.set)

def on_closing():
    '''...'''
    print("Fermeture de la fenêtre principale")
    if not cursor.close:
        cursor.close()
    if not conn.close:
        conn.close()
    root.quit()

conn = oracledb.connect(user='system', password='root', host="localhost", port=1521)
cursor = conn.cursor()

root = tk.Tk()
root.title("Analyse Financière")
root.protocol("WM_DELETE_WINDOW", on_closing)

label_query1 = tk.Label(root, text="")
label_query1.pack()

label_query2 = tk.Label(root, text="")
label_query2.pack()

label_query3 = tk.Label(root, text="")
label_query3.pack()

button_query1 = tk.Button(root, text="Plus grosse catégorie de dépense",
                          command=lambda: display_result(run_query(SELECT_CATEGORIE_D),
                                                        label_query1))
button_query1.pack()

button_query2 = tk.Button(root, text="Plus grosse sous-catégorie de revenu",
                          command=lambda: display_result(run_query(SELECT_CATEGORIE_C),
                                                        label_query2))
button_query2.pack()

button_query3 = tk.Button(root, text="Évolution du solde client",
                          command=open_new_window)
button_query3.pack()

root.mainloop()
cursor.close()
conn.close()
