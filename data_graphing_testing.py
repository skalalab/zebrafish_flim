import pandas as pd
import seaborn as sns
import matplotlib.pyplot as plt

sns.set(rc={'figure.figsize':(15,15)})
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
                    curr_temp_dict = {'replicate':replicate,
                                      'color':replicate_color_list[color_counter],
                                      'df':curr_replicate_df}
                    curr_replicate_df_dict[replicate] = curr_temp_dict
                color_counter += 1
            df_dict[condition] = {'condition':condition,
                                  'condition_df':curr_condition_df,
                                  'replicate_df_dict':curr_replicate_df_dict}
    return df_dict
def generate_figure(df,
                    condition_list,
                    x_axis_col_name,
                    y_axis_col_name,
                    fig_title,
                    y_axis_label,
                    swarmplot_size,
                    axis_line_width,
                    boxplot_line_width,
                    dotplot_replicate_alpha,
                    save_fig,
                    save_fig_filename):
    PROPS_BLACK = {'boxprops':{'facecolor':'none', 'edgecolor':'black'},
                   'medianprops':{'color':'black'},
                   'whiskerprops':{'color':'black'},
                   'capprops':{'color':'black'}}
    fig, axs = plt.subplots(ncols=len(condition_list), sharey=True)
    fig.suptitle(fig_title, fontsize=50, weight='bold')
    for ix, (condition, curr_df) in enumerate(df.items()):
        sns.boxplot(x=x_axis_col_name,
                    y=y_axis_col_name,
                    data=curr_df['condition_df'],
                    ax= axs[ix],
                    linewidth=boxplot_line_width,
                    **PROPS_BLACK)
        for (replicate, replicate_df) in curr_df['replicate_df_dict'].items():
            sns.swarmplot(x=x_axis_col_name,
                          y=y_axis_col_name,
                          data=replicate_df['df'],
                          color=replicate_df['color'],
                          size=swarmplot_size,
                          ax=axs[ix],
                          alpha=dotplot_replicate_alpha)

    for ix, ax in enumerate(axs):
        if ix == 0:
            sns.despine(left=False, bottom=False, right=True, ax=ax)
            ax.spines['left'].set_linewidth(axis_line_width)
            ax.spines['bottom'].set_linewidth(axis_line_width)
            ax.set_yticks([round(i, 2) for i in ax.get_yticks()])
            ax.set_yticklabels([str(round(i, 2)) for i in ax.get_yticks()], fontsize=20, weight='bold')
            ax.set_xticklabels([str(i) for i in ax.get_xticks()], fontsize=0)
            ax.set_xlabel(condition_list[ix], fontsize=30, weight='bold')
            ax.set_ylabel(y_axis_label, fontsize=30, weight='bold')
        else:
            sns.despine(left=True, bottom=False, right=True, ax=ax)
            ax.spines['bottom'].set_linewidth(axis_line_width)
            ax.set_xlabel(condition_list[ix], fontsize=30, weight='bold')
            ax.set_ylabel(y_axis_label, fontsize=0, weight='bold')
            ax.set_xticklabels([str(i) for i in ax.get_xticks()], fontsize=0)
    if save_fig:
        fig.savefig(save_fig_filename, transparent=True)
