import pandas as pd
import seaborn as sns
import numpy as np 
import matplotlib.pyplot as plt
import matplotlib.ticker as ticker

sns.set(rc={'figure.figsize': (15, 15)})
sns.set_style(style='white')
plt.rcParams['svg.fonttype'] = 'none'


def generate_sub_dataframes(df,
                            x_axis_col_name,
                            y_axis_col_name,
                            replicate_id_col_name,
                            replicate_id_list,
                            replicate_color_list,
                            condition_list):
    df_dict = dict()
    color_counter = 0
    if x_axis_col_name not in df.columns:
        raise ValueError(f'Please double check x axis column name! Acceptable column names: {list(df.columns)}')
    if replicate_id_col_name not in df.columns:
        raise ValueError(f'Please double check replicate column name! Acceptable column names: {list(df.columns)}')
    if y_axis_col_name not in df.columns:
        raise ValueError(f'Please double check y axis column name! Acceptable column names: {list(df.columns)}')
    for condition in condition_list:
        curr_condition_df = df[df[x_axis_col_name] == condition]
        if len(curr_condition_df) != 0:
            curr_replicate_df_dict = dict()
            for replicate in replicate_id_list:
                curr_replicate_df = curr_condition_df[curr_condition_df[replicate_id_col_name] == replicate]
                if len(curr_replicate_df) != 0:
                    curr_temp_dict = {'replicate': replicate,
                                      'color': replicate_color_list[color_counter],
                                      'df': curr_replicate_df}
                    curr_replicate_df_dict[replicate] = curr_temp_dict
                color_counter += 1
            df_dict[condition] = {'condition': condition,
                                  'condition_df': curr_condition_df,
                                  'replicate_df_dict': curr_replicate_df_dict}
    return df_dict


def generate_figure(df,
                    condition_list,
                    x_axis_col_name,
                    y_axis_col_name,
                    fig_title,
                    figsize,
                    fig_title_size, 
                    fig_title_style,
                    y_axis_label,
                    y_axis_label_size,
                    y_axis_label_style,
                    x_axis_label,
                    x_axis_label_size, 
                    x_axis_label_style,
                    x_axis_data_labels,
                    x_axis_data_label_size, 
                    x_axis_data_label_style,
                    swarmplot_size,
                    axis_line_width,
                    y_axis_tick_thickness,
                    y_axis_tick_label_size, 
                    y_axis_tick_label_style,
                    boxplot_line_width,
                    boxplot_width,
                    dotplot_replicate_alpha,
                    save_fig,
                    save_fig_filename, 
                    y_axis_ticks=None):
    PROPS_BLACK = {'boxprops': {'facecolor': 'none', 'edgecolor': 'black'},
                   'medianprops': {'color': 'black'},
                   'whiskerprops': {'color': 'black'},
                   'capprops': {'color': 'black'}}
    fig, axs = plt.subplots(ncols=len(condition_list),figsize=figsize, sharey=True, sharex=True)
    fig.suptitle(fig_title, fontsize=fig_title_size, weight=fig_title_style)
    fig.supxlabel(x_axis_label, fontsize=x_axis_label_size, weight=x_axis_label_style)
    for ix, (condition, curr_df) in enumerate(df.items()):
        
        for (replicate, replicate_df) in curr_df['replicate_df_dict'].items():
            sns.swarmplot(x=x_axis_col_name,
                          y=y_axis_col_name,
                          data=replicate_df['df'],
                          color=replicate_df['color'],
                          size=swarmplot_size,
                          ax=axs[ix],
                          alpha=dotplot_replicate_alpha, zorder=0.5)
        sns.boxplot(x=x_axis_col_name,
                    y=y_axis_col_name,
                    data=curr_df['condition_df'],
                    ax=axs[ix],
                    linewidth=boxplot_line_width,
                    width=boxplot_width,
                    showfliers=False,
                    zorder=1,
                    **PROPS_BLACK)
    for ix, ax in enumerate(axs):
        if y_axis_ticks: 
            ticks = [round(i, 2) for i in np.arange(y_axis_ticks[0], y_axis_ticks[1], round(y_axis_ticks[1]/y_axis_ticks[2], 3))]
            ticks.append(y_axis_ticks[1])
            plt.ylim(y_axis_ticks[0], y_axis_ticks[1])
        else:
            ticks = ax.get_yticks()
        if ix == 0:
            sns.despine(left=False, bottom=False, right=True, ax=ax)
            ax.spines['left'].set_linewidth(axis_line_width)
            ax.spines['bottom'].set_linewidth(axis_line_width)
            ax.set_yticks(ticks)
            ax.yaxis.set_tick_params(width=y_axis_tick_thickness)
            ax.set_yticklabels([str(round(i, 2)) for i in ticks], fontsize=y_axis_tick_label_size, weight=y_axis_tick_label_style)
            ax.set_xticklabels([str(i) for i in ax.get_xticks()], fontsize=0)
            ax.set_xlabel(x_axis_data_labels[ix], fontsize=x_axis_data_label_size, weight=x_axis_data_label_style)
            ax.set_ylabel(y_axis_label, fontsize=y_axis_label_size, weight=y_axis_label_style)
            ax.tick_params(left=True, length=10)
        else:
            sns.despine(left=True, bottom=False, right=True, ax=ax)
            ax.spines['bottom'].set_linewidth(axis_line_width)
            ax.set_xlabel(x_axis_data_labels[ix], fontsize=x_axis_data_label_size, weight=x_axis_data_label_style)
            ax.set_yticks(ticks)
            ax.set_yticklabels([str(round(i, 2)) for i in ticks], fontsize=0, weight='bold')
            ax.set_ylabel(y_axis_label, fontsize=0, weight='bold')
            ax.set_xticklabels([str(i) for i in ax.get_xticks()], fontsize=0)
    
    if save_fig:
        fig.savefig(save_fig_filename, transparent=True)
