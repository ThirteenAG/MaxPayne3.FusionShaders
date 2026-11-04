sampler2D blitSampler : register(s2);
float4 gStencil : register(c61);
sampler2D imposterSampler : register(s1);

struct PS_IN
{
	float4 texcoord : TEXCOORD;
	float4 texcoord1 : TEXCOORD1;
	float4 texcoord2 : TEXCOORD2;
	float4 texcoord3 : TEXCOORD3;
	float4 texcoord4 : TEXCOORD4;
	float3 texcoord5 : TEXCOORD5;
	float3 texcoord6 : TEXCOORD6;
	float3 texcoord7 : TEXCOORD7;
	float4 color : COLOR;
};

struct PS_OUT
{
	float4 color : COLOR;
	float4 color1 : COLOR1;
	float4 color2 : COLOR2;
	float4 color3 : COLOR3;
};

PS_OUT main(PS_IN i)
{
	PS_OUT o;

	float4 r0;
	float4 r1;
	float4 r2;
	r0 = tex2D(imposterSampler, i.texcoord.xy);
	r1 = r0 * 15.93775;
	r1 = frac(r1);
	r1 = r1 * 16;
	r0 = r0 * 255.004 + -r1;
	r0 = r0 * 0.0625;
	r2.x = dot(r0, i.texcoord4);
	r0.x = dot(r0, i.texcoord2);
	r0.y = dot(r1, i.texcoord3);
	r0.z = dot(r1, i.texcoord1);
	r0.x = r0.x + r0.z;
	r0.y = r2.x + r0.y;
	r0.zw = saturate(r0.yx);
	r0.z = r0.z * i.texcoord.w;
	r0.z = r0.w * i.texcoord.z + r0.z;
	o.color.w = r0.z * i.color.w;
	r0.z = frac(r0.x);
	r0.x = -r0.z + r0.x;
	r1.x = r0.x * 0.0625;
	r1.yw = 0.5;
	r2 = tex2D(blitSampler, r1.xy);
	r0.xzw = r2.xyz * 2 + -1;
	r1.x = frac(r0.y);
	r0.y = r0.y + -r1.x;
	r1.z = r0.y * 0.0625;
	r1 = tex2D(blitSampler, r1.zw);
	r1.xyz = r1.xyz * 2 + -1;
	r1.xyz = r1.xyz * i.texcoord.www;
	r0.xyz = r0.xzw * i.texcoord.zzz + r1.xyz;
	r0.xyz = r0.xyz + 1E-05;
	r1.xyz = normalize(r0.xyz);
	r0.xyz = r1.yyy * i.texcoord6.xyz;
	r0.xyz = i.texcoord5.xyz * r1.xxx + r0.xyz;
	r0.xyz = i.texcoord7.xyz * r1.zzz + r0.xyz;
	o.color1.xyz = r0.xyz * 0.5 + 0.5;
	r0 = tex2D(imposterSampler, float2(0.9921875, 0.0078125));
	o.color.xyz = r0.xyz;
	o.color1.w = 0;
	o.color2 = float4(0, 0.5, 0.5, 0);
	r0.yz = float2(-1, 0);
	o.color3 = abs(r0.zzzy) * gStencil.x;

	return o;
}
